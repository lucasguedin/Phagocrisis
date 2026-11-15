extends Area2D

@export var vel_bala: float = 550.0
@export var dano_bala: int = 1

var dir_voo: Vector2 = Vector2.RIGHT
var duracao: float = 3.0
var acertou_algo: bool = false

func _ready() -> void:
	body_entered.connect(_bateu_em_corpo)

func disparar(origem: Vector2, direcao: Vector2, cor: Color = Color.WHITE, forca: int = 1):
	global_position = origem
	dir_voo = direcao.normalized()
	# corrige rotacao pq o sprite do tiro aponta pra cima
	rotation = dir_voo.angle() + PI * 0.5
	modulate = cor
	dano_bala = forca


func _physics_process(delta: float) -> void:
	if acertou_algo:
		return

	position += dir_voo * vel_bala * delta
	duracao -= delta

	var area_tela := Rect2(-32.0, -32.0, 1344.0, 784.0)
	if duracao <= 0.0 or not area_tela.has_point(global_position):
		queue_free()
		return

	_testar_acerto_portal()

func _testar_acerto_portal():
	for no in get_tree().get_nodes_in_group("spawners"):
		var spawner = no as Node2D
		if spawner != null and is_instance_valid(spawner):
			if global_position.distance_to(spawner.global_position) <= 24.0:
				acertou_algo = true
				spawner.take_damage(dano_bala)
				queue_free()
				break

func _bateu_em_corpo(corpo: Node) -> void:
	if acertou_algo or corpo.is_in_group("player"):
		return
	if corpo.has_method("take_damage"):
		acertou_algo = true
		corpo.take_damage(dano_bala)
		queue_free()
	elif corpo is TileMapLayer or corpo is StaticBody2D:
		acertou_algo = true
		queue_free()
