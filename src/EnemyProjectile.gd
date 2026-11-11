extends Area2D

@export var speed: float = 280.0
@export var damage: int = 1

var direction: Vector2 = Vector2.DOWN
var _lifetime: float = 4.0
var _hit_consumed: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func setup(pos: Vector2, dir: Vector2, proj_speed: float = 280.0) -> void:
	global_position = pos
	direction = dir.normalized()
	speed = proj_speed

func _physics_process(delta: float) -> void:
	if _hit_consumed:
		return

	global_position += direction * speed * delta
	rotation += 6.0 * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()
		return
	if global_position.x < -32.0 or global_position.x > 1312.0 or global_position.y < -32.0 or global_position.y > 752.0:
		queue_free()
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player != null and is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= 20.0:
			if player.has_method("take_damage"):
				_hit_consumed = true
				player.take_damage(damage, global_position)
				queue_free()

func _on_body_entered(body: Node) -> void:
	if _hit_consumed:
		return
	if body.is_in_group("enemies") or body.is_in_group("spawners"):
		return
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			_hit_consumed = true
			body.take_damage(damage, global_position)
			queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		_hit_consumed = true
		queue_free()

