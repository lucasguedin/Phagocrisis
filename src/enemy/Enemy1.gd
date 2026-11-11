extends CharacterBody2D

const DropScript = preload("res://src/DropPickup.gd")

enum Estado {
	PATRULHA,
	PERSEGUINDO
}

const DIRECOES_CARDINAIS: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]

const CELULA_INVALIDA: Vector2i = Vector2i(-999999, -999999)

@export_group("Movimento")
@export var patrol_speed: float = 75.0
@export var chase_speed: float = 115.0
@export var acceleration: float = 350.0
@export var deceleration: float = 400.0

@export_group("Combate")
@export var max_health: int = 3
@export var score_value: int = 150

@export_group("Detecção do Player")
@export var detection_distance: float = 420.0
@export var lose_distance: float = 650.0
@export var stop_distance: float = 0.0

@export_group("Patrulha")
@export var min_patrol_time: float = 1.0
@export var max_patrol_time: float = 4.0

@export_group("Perseguição por Caminhos")
@export var intervalo_recalculo_caminho: float = 0.25
@export var tolerancia_waypoint: float = 4.0
@export var raio_busca_celula: int = 8

@onready var mapa_fundo: TileMapLayer = get_node_or_null("../fundo") as TileMapLayer
@onready var mapa_parede: TileMapLayer = get_node_or_null("../parede") as TileMapLayer
@onready var sprite: Sprite2D = get_node_or_null("Fann") as Sprite2D
@onready var col_shape: CollisionShape2D = get_node_or_null("CollisionShape2D") as CollisionShape2D

var health: int = 3
var _hurt_flash_timer: float = 0.0
var _attack_cooldown: float = 0.0

var _estado: int = Estado.PATRULHA
var _player: Node2D = null
var _random: RandomNumberGenerator = RandomNumberGenerator.new()

var _direcao_patrulha: Vector2 = Vector2.RIGHT
var _ultima_direcao_patrulha: Vector2 = Vector2.ZERO

var _timer_patrulha: float = 0.0
var _timer_busca_player: float = 0.0
var _timer_recalculo_caminho: float = 0.0

var _astar: AStarGrid2D
var _grade_pronta: bool = false
var _rota: Array[Vector2i] = []
var _indice_rota: int = 0
var _celula_origem_cache: Vector2i = CELULA_INVALIDA
var _celula_alvo_cache: Vector2i = CELULA_INVALIDA

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	add_to_group("enemies")
	health = max_health
	GameState.call_deferred("refresh_counts", get_tree())

	# Normaliza posição caso o Sprite2D/CollisionShape2D tivesse offset na cena
	if sprite != null:
		if sprite.position != Vector2.ZERO:
			global_position = sprite.position
			sprite.position = Vector2.ZERO
		sprite.scale = Vector2(1.6, 1.6)
	if col_shape != null and col_shape.position != Vector2.ZERO:
		col_shape.position = Vector2.ZERO

	_random.randomize()
	_configurar_grade()
	_procurar_player(false)
	_escolher_nova_patrulha()

func _physics_process(delta: float) -> void:
	if _hurt_flash_timer > 0.0:
		_hurt_flash_timer -= delta
		if sprite != null:
			sprite.modulate = Color(2.5, 0.4, 0.4, 1.0) if _hurt_flash_timer > 0.0 else Color.WHITE

	if _attack_cooldown > 0.0:
		_attack_cooldown -= delta

	_atualizar_referencia_player(delta)

	if is_instance_valid(_player):
		_atualizar_estado()

	if _estado == Estado.PATRULHA:
		_atualizar_patrulha(delta)
	else:
		_atualizar_perseguicao(delta)

	move_and_slide()

	# Dano de contato no protagonista (por colisão física ou proximidade dos corpos)
	if is_instance_valid(_player) and _attack_cooldown <= 0.0:
		var encostou: bool = global_position.distance_to(_player.global_position) <= 44.0
		if not encostou:
			for i in range(get_slide_collision_count()):
				var col := get_slide_collision(i)
				if col != null and col.get_collider() == _player:
					encostou = true
					break
		if encostou and _player.has_method("take_damage"):
			_player.take_damage(1, global_position)
			_attack_cooldown = 0.75

	if _estado == Estado.PATRULHA and get_slide_collision_count() > 0:
		_reagir_a_colisao_patrulha()

	if sprite != null and absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	_hurt_flash_timer = 0.12
	if sprite != null:
		sprite.modulate = Color(2.5, 0.4, 0.4, 1.0)
	queue_redraw()
	if health <= 0:
		_morrer()

func _morrer() -> void:
	var tree: SceneTree = get_tree()
	remove_from_group("enemies")
	GameState.add_score(score_value)

	# Dropa orbe de energia/cura no chão
	if tree != null and tree.current_scene != null and _random.randf() <= 0.65:
		var drop := Area2D.new()
		drop.set_script(DropScript)
		tree.current_scene.call_deferred("add_child", drop)
		var tipo: int = DropScript.DropType.SPREAD_BUFF if _random.randf() < 0.2 else DropScript.DropType.ENERGY_ORB
		drop.call_deferred("setup", global_position, tipo)

	# Verifica se destruiu todos os spawners e limpou todos os inimigos
	if tree != null:
		GameState.check_room_victory(tree)

	queue_free()

func _draw() -> void:
	if health < max_health and health > 0:
		var w: float = 26.0
		var ratio: float = clampf(float(health) / float(max_health), 0.0, 1.0)
		draw_rect(Rect2(Vector2(-w * 0.5, 18.0), Vector2(w, 4.0)), Color(0.1, 0.1, 0.1, 0.9))
		draw_rect(Rect2(Vector2(-w * 0.5, 18.0), Vector2(w * ratio, 4.0)), Color(0.95, 0.2, 0.2, 1.0))

func _procurar_player(mostrar_aviso: bool = false) -> void:
	var encontrado: Node = get_tree().get_first_node_in_group("player")
	if encontrado is Node2D:
		_player = encontrado as Node2D
	elif mostrar_aviso:
		push_warning("Inimigo: jogador não encontrado.")

func _atualizar_referencia_player(delta: float) -> void:
	if is_instance_valid(_player):
		return
	_player = null
	_timer_busca_player -= delta
	if _timer_busca_player <= 0.0:
		_procurar_player()
		_timer_busca_player = 1.0

func _atualizar_estado() -> void:
	var distancia: float = global_position.distance_to(_player.global_position)
	if _estado == Estado.PATRULHA and distancia <= detection_distance:
		_estado = Estado.PERSEGUINDO
		_rota.clear()
		_indice_rota = 0
		_timer_recalculo_caminho = 0.0
	elif _estado == Estado.PERSEGUINDO and distancia > lose_distance:
		_estado = Estado.PATRULHA
		_rota.clear()
		_indice_rota = 0
		_escolher_nova_patrulha()

func _configurar_grade() -> void:
	if mapa_fundo == null or mapa_parede == null or mapa_fundo.tile_set == null:
		return
	var regiao: Rect2i = mapa_fundo.get_used_rect()
	if regiao.size.x <= 0 or regiao.size.y <= 0:
		return
	var tamanho_celula := Vector2(mapa_fundo.tile_set.tile_size)
	_astar = AStarGrid2D.new()
	_astar.region = regiao
	_astar.cell_size = tamanho_celula
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.update()
	_astar.fill_solid_region(regiao, true)
	for celula: Vector2i in mapa_fundo.get_used_cells():
		if _astar.is_in_boundsv(celula):
			_astar.set_point_solid(celula, false)
	for celula_parede: Vector2i in mapa_parede.get_used_cells():
		var posicao_global: Vector2 = mapa_parede.to_global(mapa_parede.map_to_local(celula_parede))
		var celula_fundo: Vector2i = mapa_fundo.local_to_map(mapa_fundo.to_local(posicao_global))
		if _astar.is_in_boundsv(celula_fundo):
			_astar.set_point_solid(celula_fundo, true)
	_grade_pronta = true

func _posicao_para_celula(posicao_global: Vector2) -> Vector2i:
	return mapa_fundo.local_to_map(mapa_fundo.to_local(posicao_global))

func _celula_para_posicao(celula: Vector2i) -> Vector2:
	return mapa_fundo.to_global(mapa_fundo.map_to_local(celula))

func _celula_caminhavel_mais_proxima(origem: Vector2i) -> Vector2i:
	if _astar.is_in_boundsv(origem) and not _astar.is_point_solid(origem):
		return origem
	for raio: int in range(1, raio_busca_celula + 1):
		for y: int in range(-raio, raio + 1):
			for x: int in range(-raio, raio + 1):
				if abs(x) + abs(y) != raio:
					continue
				var candidata: Vector2i = origem + Vector2i(x, y)
				if _astar.is_in_boundsv(candidata) and not _astar.is_point_solid(candidata):
					return candidata
	return CELULA_INVALIDA

func _atualizar_patrulha(delta: float) -> void:
	_timer_patrulha -= delta
	if _timer_patrulha <= 0.0:
		_escolher_nova_patrulha()
	velocity = velocity.move_toward(_direcao_patrulha * patrol_speed, acceleration * delta)

func _escolher_nova_patrulha() -> void:
	var candidatas: Array[Vector2] = []
	for direcao: Vector2 in DIRECOES_CARDINAIS:
		if not test_move(global_transform, direcao * 8.0):
			candidatas.append(direcao)
	if candidatas.is_empty():
		_direcao_patrulha = Vector2.ZERO
		_timer_patrulha = 0.5
		return
	_direcao_patrulha = candidatas[_random.randi_range(0, candidatas.size() - 1)]
	_ultima_direcao_patrulha = _direcao_patrulha
	_timer_patrulha = _random.randf_range(min_patrol_time, maxf(min_patrol_time, max_patrol_time))

func _reagir_a_colisao_patrulha() -> void:
	_escolher_nova_patrulha()

func _atualizar_perseguicao(delta: float) -> void:
	if not is_instance_valid(_player):
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		return
	if not _grade_pronta:
		velocity = global_position.direction_to(_player.global_position) * chase_speed
		return
	var distancia: float = global_position.distance_to(_player.global_position)
	if distancia <= stop_distance:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		return
	var celula_atual: Vector2i = _posicao_para_celula(global_position)
	var celula_player: Vector2i = _posicao_para_celula(_player.global_position)
	if celula_atual == celula_player or distancia < 140.0:
		velocity = global_position.direction_to(_player.global_position) * chase_speed
		return
	_timer_recalculo_caminho -= delta
	if _timer_recalculo_caminho <= 0.0 or celula_atual != _celula_origem_cache or celula_player != _celula_alvo_cache:
		_calcular_rota(celula_atual, celula_player)
	if _rota.is_empty():
		velocity = global_position.direction_to(_player.global_position) * chase_speed
		return
	while _indice_rota < _rota.size():
		var waypoint: Vector2 = _celula_para_posicao(_rota[_indice_rota])
		if global_position.distance_to(waypoint) > tolerancia_waypoint:
			break
		_indice_rota += 1
	if _indice_rota >= _rota.size():
		velocity = global_position.direction_to(_player.global_position) * chase_speed
		return
	var proximo_ponto: Vector2 = _celula_para_posicao(_rota[_indice_rota])
	velocity = (proximo_ponto - global_position).normalized() * chase_speed

func _calcular_rota(origem: Vector2i, destino: Vector2i) -> void:
	_timer_recalculo_caminho = maxf(intervalo_recalculo_caminho, 0.05)
	_celula_origem_cache = origem
	_celula_alvo_cache = destino
	_rota.clear()
	_indice_rota = 0
	var origem_caminhavel: Vector2i = _celula_caminhavel_mais_proxima(origem)
	var destino_caminhavel: Vector2i = _celula_caminhavel_mais_proxima(destino)
	if origem_caminhavel == CELULA_INVALIDA or destino_caminhavel == CELULA_INVALIDA:
		return
	var rota_calculada: Array[Vector2i] = _astar.get_id_path(origem_caminhavel, destino_caminhavel)
	if rota_calculada.is_empty():
		return
	if origem == origem_caminhavel and rota_calculada[0] == origem_caminhavel:
		rota_calculada.remove_at(0)
	_rota = rota_calculada
