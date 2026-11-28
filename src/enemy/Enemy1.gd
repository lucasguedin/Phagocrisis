extends CharacterBody2D

const ScriptDrop = preload("res://src/DropPickup.gd")
const TEX_VIRUS_MELEE = preload("res://sprites/virus_melee.png")

enum Estado { PATRULHA, PERSEGUINDO }

const DIRECOES_CARDINAIS: Array[Vector2] = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]
const CELULA_INVALIDA: Vector2i = Vector2i(-999999, -999999)

@export_group("Movimento")
@export var patrol_speed: float = 120.0
@export var chase_speed: float = 185.0
@export var acceleration: float = 650.0
@export var deceleration: float = 550.0

@export_group("Combate")
@export var max_health: int = 3
@export var score_value: int = 150

@export_group("Detecção do Player")
@export var detection_distance: float = 950.0
@export var lose_distance: float = 1300.0
@export var stop_distance: float = 0.0

@export_group("Patrulha")
@export var min_patrol_time: float = 1.0
@export var max_patrol_time: float = 4.0

@export_group("Perseguição por Caminhos")
@export var intervalo_recalculo_caminho: float = 0.2
@export var tolerancia_waypoint: float = 16.0
@export var raio_busca_celula: int = 8

@onready var mapa_fundo: TileMapLayer = get_node_or_null("../fundo") as TileMapLayer
@onready var mapa_parede: TileMapLayer = get_node_or_null("../parede") as TileMapLayer
@onready var sprite: Sprite2D = get_node_or_null("Fann") as Sprite2D
@onready var col_shape: CollisionShape2D = get_node_or_null("CollisionShape2D") as CollisionShape2D

var health: int = 3
var piscar_dano: float = 0.0
var cooldown_mordida: float = 0.0

var _estado: int = Estado.PATRULHA
var _player: Node2D = null
var _random: RandomNumberGenerator = RandomNumberGenerator.new()

var _direcao_patrulha: Vector2 = Vector2.RIGHT
var _ultima_direcao_patrulha: Vector2 = Vector2.ZERO

var _timer_patrulha: float = 0.0
var _timer_busca_player: float = 0.0
var _timer_recalculo_caminho: float = 0.0
var _tempo_travado: float = 0.0

var _astar: AStarGrid2D
var _grade_pronta: bool = false
var _rota: Array[Vector2i] = []
var _indice_rota: int = 0
var _celula_origem_cache: Vector2i = CELULA_INVALIDA
var _celula_alvo_cache: Vector2i = CELULA_INVALIDA


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	wall_min_slide_angle = 0.0
	safe_margin = 0.2
	add_to_group("enemies")
	health = max_health
	GameState.call_deferred("atualizar_contagem", get_tree())

	if sprite != null:
		if sprite.position != Vector2.ZERO:
			global_position = sprite.position
			sprite.position = Vector2.ZERO
		if sprite.texture == null or sprite.texture.resource_path.ends_with("inimigoVermei.png"):
			sprite.texture = TEX_VIRUS_MELEE
		sprite.scale = Vector2(1.5, 1.5)

	if col_shape != null:
		col_shape.position = Vector2.ZERO
		# colisor circular evita enroscar na quina de 90 graus dos tiles de parede
		var circ := CircleShape2D.new()
		circ.radius = 18.0 if max_health > 20 else 11.0
		col_shape.shape = circ

	_random.randomize()
	_configurar_grade()
	_procurar_player(false)
	_escolher_nova_patrulha()


func _physics_process(delta: float) -> void:
	if piscar_dano > 0.0:
		piscar_dano -= delta
		if sprite != null:
			sprite.modulate = Color(2.5, 0.4, 0.4) if piscar_dano > 0.0 else Color.WHITE

	if cooldown_mordida > 0.0:
		cooldown_mordida -= delta

	_atualizar_referencia_player(delta)
	if is_instance_valid(_player):
		_atualizar_estado()

	if _estado == Estado.PATRULHA:
		_atualizar_patrulha(delta)
	else:
		_atualizar_perseguicao(delta)

	move_and_slide()

	if is_instance_valid(_player) and cooldown_mordida <= 0.0:
		var encostou := global_position.distance_to(_player.global_position) <= 44.0
		if not encostou:
			for i in range(get_slide_collision_count()):
				var col = get_slide_collision(i)
				if col != null and col.get_collider() == _player:
					encostou = true
					break
		if encostou and _player.has_method("take_damage"):
			_player.take_damage(1, global_position)
			cooldown_mordida = 0.75

	if _estado == Estado.PATRULHA and get_slide_collision_count() > 0:
		_reagir_a_colisao_patrulha()

	if sprite != null and absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0


func take_damage(qtd: int) -> void:
	if health <= 0:
		return
	health -= qtd
	piscar_dano = 0.12
	if sprite != null:
		sprite.modulate = Color(2.5, 0.4, 0.4)
	queue_redraw()

	if health <= 0:
		_eliminar()

func _eliminar():
	var tree = get_tree()
	remove_from_group("enemies")
	GameState.somar_pontos(score_value)

	if tree != null and tree.current_scene != null and _random.randf() <= 0.12:
		var item = Area2D.new()
		item.set_script(ScriptDrop)
		tree.current_scene.call_deferred("add_child", item)
		var t_drop = ScriptDrop.TipoItem.CURA_FORTE if _random.randf() < 0.18 else ScriptDrop.TipoItem.ORBE_ATP
		item.call_deferred("iniciar_drop", global_position, t_drop)

	if tree != null:
		GameState.checar_sala_limpa(tree)
	queue_free()

func _draw() -> void:
	if health < max_health and health > 0:
		var l := 26.0
		var pct := clampf(float(health) / float(max_health), 0.0, 1.0)
		draw_rect(Rect2(Vector2(-l * 0.5, 18.0), Vector2(l, 4.0)), Color(0.1, 0.1, 0.1, 0.9))
		draw_rect(Rect2(Vector2(-l * 0.5, 18.0), Vector2(l * pct, 4.0)), Color(0.95, 0.2, 0.2))


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

	_astar = AStarGrid2D.new()
	_astar.region = regiao
	_astar.cell_size = Vector2(mapa_fundo.tile_set.tile_size)
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	_astar.update()
	_astar.fill_solid_region(regiao, true)

	for celula: Vector2i in mapa_fundo.get_used_cells():
		if _astar.is_in_boundsv(celula):
			_astar.set_point_solid(celula, false)

	var paredes_solidas: Array[Vector2i] = []
	for celula_parede: Vector2i in mapa_parede.get_used_cells():
		var pos_global: Vector2 = mapa_parede.to_global(mapa_parede.map_to_local(celula_parede))
		var cel_fundo: Vector2i = mapa_fundo.local_to_map(mapa_fundo.to_local(pos_global))
		if _astar.is_in_boundsv(cel_fundo):
			_astar.set_point_solid(cel_fundo, true)
			paredes_solidas.append(cel_fundo)

	# aumenta o peso das celulas coladas em paredes pra rota contornar as quinas com folga
	for cel_p: Vector2i in paredes_solidas:
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx == 0 and dy == 0:
					continue
				var viz := cel_p + Vector2i(dx, dy)
				if _astar.is_in_boundsv(viz) and not _astar.is_point_solid(viz):
					_astar.set_point_weight_scale(viz, 4.5)

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
				var cand: Vector2i = origem + Vector2i(x, y)
				if _astar.is_in_boundsv(cand) and not _astar.is_point_solid(cand):
					return cand
	return CELULA_INVALIDA


func _atualizar_patrulha(delta: float) -> void:
	_timer_patrulha -= delta
	if _timer_patrulha <= 0.0:
		_escolher_nova_patrulha()
	velocity = velocity.move_toward(_direcao_patrulha * patrol_speed, acceleration * delta)

func _escolher_nova_patrulha() -> void:
	var opcoes: Array[Vector2] = []
	for dir: Vector2 in DIRECOES_CARDINAIS:
		if not test_move(global_transform, dir * 10.0):
			opcoes.append(dir)
	if opcoes.is_empty():
		_direcao_patrulha = Vector2.ZERO
		_timer_patrulha = 0.5
		return
	_direcao_patrulha = opcoes[_random.randi_range(0, opcoes.size() - 1)]
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

	var dist: float = global_position.distance_to(_player.global_position)
	if dist <= stop_distance:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
		return

	var dir_player := global_position.direction_to(_player.global_position)
	var caminho_livre := not test_move(global_transform, dir_player * minf(dist, 42.0))

	var cel_atual: Vector2i = _posicao_para_celula(global_position)
	var cel_player: Vector2i = _posicao_para_celula(_player.global_position)
	if (cel_atual == cel_player or dist < 110.0) and caminho_livre:
		velocity = dir_player * chase_speed
		return

	_timer_recalculo_caminho -= delta
	if _timer_recalculo_caminho <= 0.0 or cel_atual != _celula_origem_cache or cel_player != _celula_alvo_cache:
		_calcular_rota(cel_atual, cel_player)

	while _indice_rota < _rota.size():
		var wp: Vector2 = _celula_para_posicao(_rota[_indice_rota])
		if global_position.distance_to(wp) <= tolerancia_waypoint:
			_indice_rota += 1
		elif _indice_rota + 1 < _rota.size():
			var prox_wp: Vector2 = _celula_para_posicao(_rota[_indice_rota + 1])
			var dir_prox := global_position.direction_to(prox_wp)
			if global_position.distance_to(prox_wp) < global_position.distance_to(wp) and not test_move(global_transform, dir_prox * 18.0):
				_indice_rota += 1
			else:
				break
		else:
			break

	var dir_desejada := dir_player
	if _indice_rota < _rota.size():
		var pto: Vector2 = _celula_para_posicao(_rota[_indice_rota])
		dir_desejada = global_position.direction_to(pto)

	# se estiver raspando numa quina de parede, desliza pela tangente livre
	if test_move(global_transform, dir_desejada * 12.0):
		var melhor_dir := Vector2.ZERO
		var menor_ang := 999.0
		for ang_teste in [-35.0, 35.0, -65.0, 65.0, -90.0, 90.0, -125.0, 125.0]:
			var cand := dir_desejada.rotated(deg_to_rad(ang_teste))
			if not test_move(global_transform, cand * 14.0):
				var diff_ang := absf(deg_to_rad(ang_teste))
				if diff_ang < menor_ang:
					menor_ang = diff_ang
					melhor_dir = cand
		if melhor_dir != Vector2.ZERO:
			dir_desejada = melhor_dir
		elif _indice_rota + 1 < _rota.size():
			_indice_rota += 1

	if get_real_velocity().length() < chase_speed * 0.2:
		_tempo_travado += delta
		if _tempo_travado >= 0.25:
			_tempo_travado = 0.0
			if _indice_rota + 1 < _rota.size():
				_indice_rota += 1
			else:
				_calcular_rota(cel_atual, cel_player)
	else:
		_tempo_travado = 0.0

	velocity = dir_desejada * chase_speed

func _calcular_rota(origem: Vector2i, destino: Vector2i) -> void:
	_timer_recalculo_caminho = maxf(intervalo_recalculo_caminho, 0.05)
	_celula_origem_cache = origem
	_celula_alvo_cache = destino
	_rota.clear()
	_indice_rota = 0

	var orig_ok: Vector2i = _celula_caminhavel_mais_proxima(origem)
	var dest_ok: Vector2i = _celula_caminhavel_mais_proxima(destino)
	if orig_ok == CELULA_INVALIDA or dest_ok == CELULA_INVALIDA:
		return

	var caminho: Array[Vector2i] = _astar.get_id_path(orig_ok, dest_ok)
	if caminho.is_empty():
		return
	if origem == orig_ok and caminho[0] == orig_ok:
		caminho.remove_at(0)
	_rota = caminho
