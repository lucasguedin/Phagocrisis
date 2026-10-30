extends CharacterBody2D

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

@export var patrol_speed: float = 60.0
@export var chase_speed: float = 80.0
@export var acceleration: float = 300.0
@export var deceleration: float = 400.0


@export_group("Detecção do Player")

@export var detection_distance: float = 96.0
@export var lose_distance: float = 160.0
@export var stop_distance: float = 20.0


@export_group("Patrulha")

@export var min_patrol_time: float = 1.0
@export var max_patrol_time: float = 10.0


@export_group("Perseguição por Caminhos")

@export var intervalo_recalculo_caminho: float = 0.25
@export var tolerancia_waypoint: float = 3.0
@export var raio_busca_celula: int = 8


@onready var mapa_fundo: TileMapLayer = (
	get_node_or_null("../fundo") as TileMapLayer
)

@onready var mapa_parede: TileMapLayer = (
	get_node_or_null("../parede") as TileMapLayer
)

@onready var sprite: Sprite2D = (
	get_node_or_null("Fann") as Sprite2D
)


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
	# Movimento em quatro direções, típico de jogos top-down.
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	_random.randomize()

	_configurar_grade()
	_procurar_player(true)
	_escolher_nova_patrulha()


func _physics_process(delta: float) -> void:
	_atualizar_referencia_player(delta)

	if is_instance_valid(_player):
		_atualizar_estado()

	if _estado == Estado.PATRULHA:
		_atualizar_patrulha(delta)
	else:
		_atualizar_perseguicao(delta)

	move_and_slide()

	# Reage imediatamente quando a patrulha encontra uma parede.
	if (
		_estado == Estado.PATRULHA
		and get_slide_collision_count() > 0
	):
		_reagir_a_colisao_patrulha()

	# Orientação visual opcional do sprite.
	if sprite != null and absf(velocity.x) > 1.0:
		sprite.flip_h = velocity.x < 0.0


# --------------------------------------------------
# REFERÊNCIA AO JOGADOR
# --------------------------------------------------

func _procurar_player(mostrar_aviso: bool = false) -> void:
	var encontrado: Node = get_tree().get_first_node_in_group("player")

	if encontrado is Node2D:
		_player = encontrado as Node2D
	elif mostrar_aviso:
		push_warning(
            "Inimigo: jogador não encontrado. "
			+ "Adicione o nó Player ao grupo 'player'."
		)


func _atualizar_referencia_player(delta: float) -> void:
	if is_instance_valid(_player):
		return

	_player = null
	_timer_busca_player -= delta

	if _timer_busca_player <= 0.0:
		_procurar_player()
		_timer_busca_player = 1.0

	# Não continua perseguindo uma referência inexistente.
	if not is_instance_valid(_player):
		if _estado == Estado.PERSEGUINDO:
			_estado = Estado.PATRULHA
			_rota.clear()
			_escolher_nova_patrulha()


# --------------------------------------------------
# ESTADOS DA IA
# --------------------------------------------------

func _atualizar_estado() -> void:
	var distancia: float = global_position.distance_to(
		_player.global_position
	)

	# Patrulha -> perseguição.
	if _estado == Estado.PATRULHA:
		if distancia <= detection_distance:
			_estado = Estado.PERSEGUINDO
			_rota.clear()
			_indice_rota = 0
			_timer_recalculo_caminho = 0.0

	# Perseguição -> patrulha.
	elif _estado == Estado.PERSEGUINDO:
		if distancia > lose_distance:
			_estado = Estado.PATRULHA
			_rota.clear()
			_indice_rota = 0
			_escolher_nova_patrulha()


# --------------------------------------------------
# CONFIGURAÇÃO DA GRADE A*
# --------------------------------------------------

func _configurar_grade() -> void:
	if mapa_fundo == null:
		push_error(
            "Inimigo: não encontrei o TileMapLayer '../fundo'."
		)
		return

	if mapa_parede == null:
		push_error(
            "Inimigo: não encontrei o TileMapLayer '../parede'."
		)
		return

	if mapa_fundo.tile_set == null:
		push_error(
            "Inimigo: o TileMapLayer 'fundo' não possui TileSet."
		)
		return

	var regiao: Rect2i = mapa_fundo.get_used_rect()

	if regiao.size.x <= 0 or regiao.size.y <= 0:
		push_error(
            "Inimigo: o mapa 'fundo' não possui células utilizáveis."
		)
		return

	var tamanho_celula: Vector2 = Vector2(
		mapa_fundo.tile_set.tile_size
	)

	_astar = AStarGrid2D.new()

	_astar.region = regiao
	_astar.cell_size = tamanho_celula

	# O fantasma navega apenas na horizontal e vertical.
	# Isso evita atalhos diagonais por cantos de paredes.
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	_astar.default_compute_heuristic = (
		AStarGrid2D.HEURISTIC_MANHATTAN
	)
	_astar.default_estimate_heuristic = (
		AStarGrid2D.HEURISTIC_MANHATTAN
	)

	_astar.update()

	# Primeiro, bloqueia toda a grade.
	_astar.fill_solid_region(regiao, true)

	# Depois, libera somente as células existentes no fundo.
	for celula: Vector2i in mapa_fundo.get_used_cells():
		if _astar.is_in_boundsv(celula):
			_astar.set_point_solid(celula, false)

	# Por fim, bloqueia as células ocupadas pelas paredes.
	# A conversão também considera a transformação dos TileMapLayer.
	for celula_parede: Vector2i in mapa_parede.get_used_cells():
		var posicao_global: Vector2 = mapa_parede.to_global(
			mapa_parede.map_to_local(celula_parede)
		)

		var celula_fundo: Vector2i = mapa_fundo.local_to_map(
			mapa_fundo.to_local(posicao_global)
		)

		if _astar.is_in_boundsv(celula_fundo):
			_astar.set_point_solid(celula_fundo, true)

	_grade_pronta = true


# --------------------------------------------------
# CONVERSÃO ENTRE POSIÇÕES E CÉLULAS
# --------------------------------------------------

func _posicao_para_celula(posicao_global: Vector2) -> Vector2i:
	return mapa_fundo.local_to_map(
		mapa_fundo.to_local(posicao_global)
	)


func _celula_para_posicao(celula: Vector2i) -> Vector2:
	return mapa_fundo.to_global(
		mapa_fundo.map_to_local(celula)
	)


# Procura uma célula transitável próxima caso a célula
# consultada esteja bloqueada ou fora dos limites da grade.
func _celula_caminhavel_mais_proxima(
	origem: Vector2i
) -> Vector2i:
	if (
		_astar.is_in_boundsv(origem)
		and not _astar.is_point_solid(origem)
	):
		return origem

	for raio: int in range(1, raio_busca_celula + 1):
		for y: int in range(-raio, raio + 1):
			for x: int in range(-raio, raio + 1):
				# Busca em anéis de distância Manhattan.
				if abs(x) + abs(y) != raio:
					continue

				var candidata: Vector2i = (
					origem + Vector2i(x, y)
				)

				if not _astar.is_in_boundsv(candidata):
					continue

				if not _astar.is_point_solid(candidata):
					return candidata

	return CELULA_INVALIDA


# --------------------------------------------------
# PATRULHA
# --------------------------------------------------

func _atualizar_patrulha(delta: float) -> void:
	_timer_patrulha -= delta

	if _timer_patrulha <= 0.0:
		_escolher_nova_patrulha()

	var velocidade_desejada: Vector2 = (
		_direcao_patrulha * patrol_speed
	)

	velocity = velocity.move_toward(
		velocidade_desejada,
		acceleration * delta
	)


func _distancia_teste_patrulha() -> float:
	if mapa_fundo != null and mapa_fundo.tile_set != null:
		var tamanho: Vector2 = Vector2(
			mapa_fundo.tile_set.tile_size
		)

		return maxf(
			4.0,
			minf(tamanho.x, tamanho.y) * 0.45
		)

	return 8.0


func _escolher_nova_patrulha() -> void:
	var candidatas: Array[Vector2] = []
	var distancia_teste: float = _distancia_teste_patrulha()

	# Prioriza direções livres que não sejam iguais
	# à última direção escolhida.
	for direcao: Vector2 in DIRECOES_CARDINAIS:
		if direcao == _ultima_direcao_patrulha:
			continue

		if test_move(global_transform, direcao * distancia_teste):
			continue

		candidatas.append(direcao)

	# Se não houver alternativa, permite repetir a direção anterior.
	if candidatas.is_empty():
		for direcao: Vector2 in DIRECOES_CARDINAIS:
			if test_move(global_transform, direcao * distancia_teste):
				continue

			candidatas.append(direcao)

	if candidatas.is_empty():
		_direcao_patrulha = Vector2.ZERO
		velocity = Vector2.ZERO
		_timer_patrulha = 0.5
		return

	var indice: int = _random.randi_range(
		0,
		candidatas.size() - 1
	)

	_direcao_patrulha = candidatas[indice]
	_ultima_direcao_patrulha = _direcao_patrulha

	var tempo_maximo: float = maxf(
		min_patrol_time,
		max_patrol_time
	)

	_timer_patrulha = _random.randf_range(
		min_patrol_time,
		tempo_maximo
	)


func _reagir_a_colisao_patrulha() -> void:
	if get_slide_collision_count() == 0:
		return

	var colisao: KinematicCollision2D = get_slide_collision(0)
	var normal: Vector2 = colisao.get_normal()

	var candidatas: Array[Vector2] = []
	var distancia_teste: float = _distancia_teste_patrulha()

	for direcao: Vector2 in DIRECOES_CARDINAIS:
		# Só considera movimentos que se afastem da parede.
		if direcao.dot(normal) <= 0.1:
			continue

		if test_move(global_transform, direcao * distancia_teste):
			continue

		candidatas.append(direcao)

	velocity = Vector2.ZERO

	if candidatas.is_empty():
		_escolher_nova_patrulha()
		return

	var indice: int = _random.randi_range(
		0,
		candidatas.size() - 1
	)

	_direcao_patrulha = candidatas[indice]
	_ultima_direcao_patrulha = _direcao_patrulha

	_timer_patrulha = _random.randf_range(
		min_patrol_time,
		maxf(min_patrol_time, max_patrol_time)
	)


# --------------------------------------------------
# PERSEGUIÇÃO INTELIGENTE POR A*
# --------------------------------------------------

func _atualizar_perseguicao(delta: float) -> void:
	if not is_instance_valid(_player):
		velocity = velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)
		return

	# Sem grade pronta, não tenta atravessar paredes às cegas.
	if not _grade_pronta:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)
		return

	var distancia: float = global_position.distance_to(
		_player.global_position
	)

	if distancia <= stop_distance:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)
		return

	var celula_atual: Vector2i = _posicao_para_celula(
		global_position
	)

	var celula_player: Vector2i = _posicao_para_celula(
		_player.global_position
	)

	# Se ambos estão na mesma célula transitável,
	# a perseguição pode ser direta.
	if celula_atual == celula_player:
		_rota.clear()
		_indice_rota = 0

		var direcao_direta: Vector2 = (
			_player.global_position - global_position
		).normalized()

		velocity = direcao_direta * chase_speed
		return

	_timer_recalculo_caminho -= delta

	# Recalcula quando muda a posição na grade, quando o
	# jogador muda de célula ou quando o caminho expira.
	if (
		_timer_recalculo_caminho <= 0.0
		or celula_atual != _celula_origem_cache
		or celula_player != _celula_alvo_cache
	):
		_calcular_rota(celula_atual, celula_player)

	if _rota.is_empty():
		velocity = velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)
		return

	# Descarta os pontos que já foram alcançados.
	while _indice_rota < _rota.size():
		var waypoint: Vector2 = _celula_para_posicao(
			_rota[_indice_rota]
		)

		if global_position.distance_to(waypoint) > tolerancia_waypoint:
			break

		_indice_rota += 1

	# A rota precisa ser recalculada se todos os seus
	# pontos tiverem sido alcançados.
	if _indice_rota >= _rota.size():
		_timer_recalculo_caminho = 0.0

		velocity = velocity.move_toward(
			Vector2.ZERO,
			deceleration * delta
		)
		return

	var proximo_ponto: Vector2 = _celula_para_posicao(
		_rota[_indice_rota]
	)

	var direcao: Vector2 = (
		proximo_ponto - global_position
	).normalized()

	# Segue o próximo ponto da rota sem tentar cortar
	# diagonalmente pelos cantos das paredes.
	velocity = direcao * chase_speed


func _calcular_rota(
	origem: Vector2i,
	destino: Vector2i
) -> void:
	_timer_recalculo_caminho = maxf(
		intervalo_recalculo_caminho,
		0.05
	)

	_celula_origem_cache = origem
	_celula_alvo_cache = destino

	_rota.clear()
	_indice_rota = 0

	if not _grade_pronta:
		return

	var origem_caminhavel: Vector2i = (
		_celula_caminhavel_mais_proxima(origem)
	)

	var destino_caminhavel: Vector2i = (
		_celula_caminhavel_mais_proxima(destino)
	)

	if (
		origem_caminhavel == CELULA_INVALIDA
		or destino_caminhavel == CELULA_INVALIDA
	):
		return

	var rota_calculada: Array[Vector2i] = (
		_astar.get_id_path(
			origem_caminhavel,
			destino_caminhavel
		)
	)

	# Nenhuma rota encontrada: não tenta seguir em linha reta.
	if rota_calculada.is_empty():
		return

	# Se o inimigo já está em uma célula transitável,
	# remove a posição atual para seguir ao próximo ponto.
	# Se começou em uma célula bloqueada, mantém o primeiro
	# ponto para orientar o movimento até uma célula livre.
	if (
		origem == origem_caminhavel
		and rota_calculada[0] == origem_caminhavel
	):
		rota_calculada.remove_at(0)

	_rota = rota_calculada
