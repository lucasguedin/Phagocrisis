extends Area2D

@export var speed: float = 550.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT
var _lifetime: float = 3.0
var _hit_consumed: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func setup(pos: Vector2, dir: Vector2, spread_tint: Color = Color.WHITE) -> void:
	global_position = pos
	direction = dir.normalized()
	rotation = direction.angle() + PI * 0.5 # shotProtaMage.png aponta para cima por padrão
	modulate = spread_tint

func _physics_process(delta: float) -> void:
	if _hit_consumed:
		return

	global_position += direction * speed * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()
		return
	if global_position.x < -32.0 or global_position.x > 1312.0 or global_position.y < -32.0 or global_position.y > 752.0:
		queue_free()
		return

	# Verifica impacto nos Portais (Spawners)
	for node in get_tree().get_nodes_in_group("spawners"):
		var spawner := node as Node2D
		if spawner != null and is_instance_valid(spawner):
			if global_position.distance_to(spawner.global_position) <= 24.0:
				if spawner.has_method("take_damage"):
					_hit_consumed = true
					spawner.take_damage(damage)
					queue_free()
					return

func _on_body_entered(body: Node) -> void:
	if _hit_consumed:
		return
	if body.is_in_group("player"):
		return
	if body.has_method("take_damage"):
		_hit_consumed = true
		body.take_damage(damage)
		queue_free()
	elif body is TileMapLayer or body is StaticBody2D:
		_hit_consumed = true
		queue_free()
