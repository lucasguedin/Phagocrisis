extends Area2D

enum DropType { ENERGY_ORB, SPREAD_BUFF }

var drop_type: int = DropType.ENERGY_ORB
var velocity: Vector2 = Vector2.ZERO
var _lifetime: float = 15.0

func setup(pos: Vector2, type: int = DropType.ENERGY_ORB) -> void:
	global_position = pos
	drop_type = type
	var spr := Sprite2D.new()
	spr.texture = preload("res://sprites/shotProtaMage.png")
	if drop_type == DropType.SPREAD_BUFF:
		spr.scale = Vector2(1.1, 1.1)
		spr.modulate = Color(0.3, 1.0, 0.3, 1.0) # Verde ácido brilhante
	else:
		spr.scale = Vector2(0.75, 0.75)
		spr.modulate = Color(0.2, 0.9, 1.0, 1.0) # Ciano de ATP
	add_child(spr)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 12.0
	col.shape = shape
	add_child(col)

func _physics_process(delta: float) -> void:
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null or not is_instance_valid(player):
		return

	var dist := global_position.distance_to(player.global_position)
	if dist <= 95.0:
		var dir := global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(dir * 320.0, 900.0 * delta)
		global_position += velocity * delta

	if dist <= 18.0:
		if player.has_method("collect_drop"):
			player.collect_drop(drop_type)
		queue_free()

