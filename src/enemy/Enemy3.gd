extends "res://src/enemy/Enemy1.gd"

const TiroBoss = preload("res://src/EnemyProjectile.gd")
const TEX_BOSS = preload("res://sprites/boss_bacteriofago.png")
const TEX_TIRO = preload("res://sprites/virus_shot.png")

var espera_ataque: float = 1.6
var num_ataque: int = 0

func _ready() -> void:
	patrol_speed = 70.0
	chase_speed = 92.0
	max_health = 42
	score_value = 2000
	stop_distance = 60.0
	detection_distance = 900.0
	lose_distance = 1200.0
	super._ready()
	add_to_group("boss")
	if sprite != null:
		sprite.texture = TEX_BOSS
		sprite.scale = Vector2(1.75, 1.75)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	queue_redraw()
	if not is_instance_valid(_player) or get_tree().current_scene == null:
		return

	espera_ataque -= delta
	if espera_ataque > 0.0:
		return

	num_ataque += 1
	match num_ataque % 3:
		0:
			espera_ataque = 2.1
			for i in range(8):
				var ang := float(i) * (PI * 0.25)
				_soltar_projetil(Vector2(cos(ang), sin(ang)), 235.0)
		_:
			espera_ataque = 1.45
			var base := global_position.direction_to(_player.global_position)
			for desvio in [-20.0, 0.0, 20.0]:
				_soltar_projetil(base.rotated(deg_to_rad(desvio)), 300.0)

func _soltar_projetil(dir: Vector2, vel: float):
	var p = Area2D.new()
	p.set_script(TiroBoss)

	var s = Sprite2D.new()
	s.texture = TEX_TIRO
	s.scale = Vector2(1.45, 1.45)
	s.modulate = Color(0.85, 0.35, 1.0)
	p.add_child(s)

	var col = CollisionShape2D.new()
	var circ = CircleShape2D.new()
	circ.radius = 7.0
	col.shape = circ
	p.add_child(col)

	get_tree().current_scene.add_child(p)
	# ataque a distancia do bacteriofago tira 2 de vida
	p.lancar(global_position + dir * 24.0, dir, vel, 2)

func _draw() -> void:
	if health > 0:
		var larg := 68.0
		var orig := Vector2(-larg * 0.5, -56.0)
		draw_rect(Rect2(orig - Vector2(1, 1), Vector2(larg + 2, 9.0)), Color(0.08, 0.04, 0.14, 0.95))
		var prop := clampf(float(health) / float(max_health), 0.0, 1.0)
		draw_rect(Rect2(orig, Vector2(larg * prop, 7.0)), Color(0.45, 1.0, 0.35))
