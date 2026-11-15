extends Area2D

enum TipoItem { ORBE_ATP, CURA_FORTE }

var categoria: int = TipoItem.ORBE_ATP
var vel_ima: Vector2 = Vector2.ZERO
var tempo_chao: float = 15.0

func iniciar_drop(pos: Vector2, tipo: int = TipoItem.ORBE_ATP):
	global_position = pos
	categoria = tipo

	var spr = Sprite2D.new()
	spr.texture = preload("res://sprites/shotProtaMage.png")
	if categoria == TipoItem.CURA_FORTE:
		spr.scale = Vector2(1.1, 1.1)
		spr.modulate = Color(0.3, 1.0, 0.3)
	else:
		spr.scale = Vector2(0.75, 0.75)
		spr.modulate = Color(0.2, 0.9, 1.0)
	add_child(spr)

	var col = CollisionShape2D.new()
	var c = CircleShape2D.new()
	c.radius = 12.0
	col.shape = c
	add_child(col)


func _physics_process(delta: float) -> void:
	tempo_chao -= delta
	if tempo_chao <= 0.0:
		queue_free()
		return

	var p = get_tree().get_first_node_in_group("player") as Node2D
	if p == null or not is_instance_valid(p):
		return

	var dist := global_position.distance_to(p.global_position)
	if dist <= 95.0:
		vel_ima = vel_ima.move_toward(global_position.direction_to(p.global_position) * 320.0, 900.0 * delta)
		global_position += vel_ima * delta
	if dist <= 18.0:
		if p.has_method("pegar_drop"):
			p.pegar_drop(categoria)
		queue_free()
