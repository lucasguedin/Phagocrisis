extends "res://src/enemy/Enemy1.gd"

const BalaInimiga = preload("res://src/EnemyProjectile.gd")
const TEX_RANGED = preload("res://sprites/virus_ranged.png")
const TEX_GOTA = preload("res://sprites/virus_shot.png")

@export var cadencia: float = 1.85
@export var dist_max_tiro: float = 460.0

var relogio_tiro: float = 1.1

func _ready() -> void:
	patrol_speed = 65.0
	chase_speed = 92.0
	max_health = 3
	score_value = 200
	stop_distance = 175.0
	super._ready()
	if sprite != null:
		sprite.texture = TEX_RANGED
		sprite.scale = Vector2(1.5, 1.5)
	relogio_tiro = _random.randf_range(0.7, cadencia)


func _process(delta: float) -> void:
	if not is_instance_valid(_player) or get_tree().current_scene == null:
		return
	if global_position.distance_to(_player.global_position) > dist_max_tiro:
		return

	relogio_tiro -= delta
	if relogio_tiro <= 0.0:
		relogio_tiro = cadencia + _random.randf_range(-0.2, 0.3)
		var b = Area2D.new()
		b.set_script(BalaInimiga)

		var img = Sprite2D.new()
		img.texture = TEX_GOTA
		img.scale = Vector2(1.2, 1.2)
		b.add_child(img)

		var col = CollisionShape2D.new()
		var c = CircleShape2D.new()
		c.radius = 6.0
		col.shape = c
		b.add_child(col)

		var d := global_position.direction_to(_player.global_position)
		get_tree().current_scene.add_child(b)
		b.lancar(global_position + d * 16.0, d, 260.0, 1)
