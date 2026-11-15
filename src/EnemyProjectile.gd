extends Area2D

var vetor_mov: Vector2 = Vector2.DOWN
var velocidade: float = 280.0
var dano_ataque: int = 1
var tempo_ativo: float = 4.0
var ja_colidiu: bool = false

func _ready() -> void:
	body_entered.connect(_on_body)

func lancar(pos_ini: Vector2, dir: Vector2, vel: float = 280.0, dano: int = 1):
	global_position = pos_ini
	vetor_mov = dir.normalized()
	velocidade = vel
	dano_ataque = dano


func _physics_process(delta: float) -> void:
	if not ja_colidiu:
		translate(vetor_mov * velocidade * delta)
		rotation += 6.0 * delta
		tempo_ativo -= delta

		if tempo_ativo <= 0.0 or absf(global_position.x - 640.0) > 680.0 or absf(global_position.y - 360.0) > 400.0:
			queue_free()
		else:
			var alvo = get_tree().get_first_node_in_group("player") as Node2D
			if alvo != null and is_instance_valid(alvo) and global_position.distance_to(alvo.global_position) <= 20.0:
				ja_colidiu = true
				alvo.take_damage(dano_ataque, global_position)
				queue_free()

func _on_body(b: Node) -> void:
	if ja_colidiu or b.is_in_group("enemies") or b.is_in_group("spawners"):
		return
	if b.is_in_group("player") and b.has_method("take_damage"):
		ja_colidiu = true
		b.take_damage(dano_ataque, global_position)
		queue_free()
	elif b is TileMapLayer or b is StaticBody2D:
		ja_colidiu = true
		queue_free()
