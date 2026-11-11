extends "res://src/enemy/Enemy1.gd"

const EnemyProjScript = preload("res://src/EnemyProjectile.gd")
const TEX_VIRUS_RANGED = preload("res://sprites/virus_ranged.png")
const TEX_VIRUS_SHOT = preload("res://sprites/virus_shot.png")

@export var shoot_interval: float = 1.85
@export var shoot_range: float = 460.0

var _shoot_timer: float = 1.2

func _ready() -> void:
	patrol_speed = 65.0
	chase_speed = 92.0
	max_health = 3
	score_value = 200
	stop_distance = 175.0
	super._ready()
	if sprite != null:
		sprite.texture = TEX_VIRUS_RANGED
		sprite.scale = Vector2(1.5, 1.5)
	_shoot_timer = _random.randf_range(0.8, shoot_interval)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if not is_instance_valid(_player):
		return

	var dist: float = global_position.distance_to(_player.global_position)
	if dist <= shoot_range:
		_shoot_timer -= delta
		if _shoot_timer <= 0.0:
			_shoot_timer = shoot_interval + _random.randf_range(-0.2, 0.3)
			_disparar_proj_viral()

func _disparar_proj_viral() -> void:
	if get_tree() == null or get_tree().current_scene == null or not is_instance_valid(_player):
		return

	var proj := Area2D.new()
	proj.set_script(EnemyProjScript)

	var spr := Sprite2D.new()
	spr.texture = TEX_VIRUS_SHOT
	spr.scale = Vector2(1.2, 1.2)
	proj.add_child(spr)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 6.0
	col.shape = shape
	proj.add_child(col)

	var dir: Vector2 = global_position.direction_to(_player.global_position)
	get_tree().current_scene.add_child(proj)
	proj.setup(global_position + dir * 16.0, dir, 260.0)
