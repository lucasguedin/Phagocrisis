extends "res://src/enemy/Enemy1.gd"

const EnemyProjScript = preload("res://src/EnemyProjectile.gd")
const TEX_BOSS = preload("res://sprites/boss_bacteriofago.png")
const TEX_VIRUS_SHOT = preload("res://sprites/virus_shot.png")

var _boss_attack_timer: float = 1.6
var _attack_cycle: int = 0

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
	if not is_instance_valid(_player):
		return

	_boss_attack_timer -= delta
	if _boss_attack_timer <= 0.0:
		_attack_cycle += 1
		if _attack_cycle % 3 == 0:
			_boss_attack_timer = 2.1
			_disparar_anel_viral()
		else:
			_boss_attack_timer = 1.45
			_disparar_rajada_tripla()

func _disparar_rajada_tripla() -> void:
	if get_tree() == null or get_tree().current_scene == null or not is_instance_valid(_player):
		return
	var base_dir: Vector2 = global_position.direction_to(_player.global_position)
	var angs: Array = [-20.0, 0.0, 20.0]
	for deg in angs:
		_criar_tiro_boss(base_dir.rotated(deg_to_rad(float(deg))), 300.0)

func _disparar_anel_viral() -> void:
	if get_tree() == null or get_tree().current_scene == null:
		return
	for i in range(8):
		var ang: float = float(i) * (PI * 0.25)
		var dir := Vector2(cos(ang), sin(ang))
		_criar_tiro_boss(dir, 235.0)

func _criar_tiro_boss(dir: Vector2, proj_speed: float) -> void:
	var proj := Area2D.new()
	proj.set_script(EnemyProjScript)

	var spr := Sprite2D.new()
	spr.texture = TEX_VIRUS_SHOT
	spr.scale = Vector2(1.45, 1.45)
	spr.modulate = Color(0.85, 0.35, 1.0, 1.0)
	proj.add_child(spr)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 7.0
	col.shape = shape
	proj.add_child(col)

	get_tree().current_scene.add_child(proj)
	proj.setup(global_position + dir * 24.0, dir, proj_speed)

func _draw() -> void:
	if health > 0:
		var w: float = 68.0
		var h: float = 7.0
		var ratio: float = clampf(float(health) / float(max_health), 0.0, 1.0)
		var pos := Vector2(-w * 0.5, -56.0)
		draw_rect(Rect2(pos - Vector2(1, 1), Vector2(w + 2, h + 2)), Color(0.08, 0.04, 0.14, 0.95))
		draw_rect(Rect2(pos, Vector2(w * ratio, h)), Color(0.45, 1.0, 0.35, 1.0))
