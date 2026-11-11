extends Sprite2D

const Enemy1Script = preload("res://src/enemy/Enemy1.gd")
const Enemy2Script = preload("res://src/enemy/Enemy2.gd")
const DropScript = preload("res://src/DropPickup.gd")

const TEX_MELEE = preload("res://sprites/virus_melee.png")
const TEX_RANGED = preload("res://sprites/virus_ranged.png")

@export var spawn_interval: float = 4.0
@export var max_concurrent_enemies: int = 7
@export var max_health: int = 10
@export var score_value: int = 500

var health: int = 10
var _hurt_flash_timer: float = 0.0
var _timer: float = 2.2
var _pulse_time: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	health = max_health
	add_to_group("spawners")
	GameState.call_deferred("refresh_counts", get_tree())
	queue_redraw()

func _process(delta: float) -> void:
	if _hurt_flash_timer > 0.0:
		_hurt_flash_timer -= delta
		modulate = Color(2.8, 0.35, 0.55, 1.0) if _hurt_flash_timer > 0.0 else Color.WHITE

	_pulse_time += delta * 4.0
	var s: float = 1.15 + 0.12 * sin(_pulse_time)
	scale = Vector2(s, s)

	var vivos: int = get_tree().get_nodes_in_group("enemies").size()
	if vivos >= max_concurrent_enemies:
		return

	_timer -= delta
	if _timer <= 0.0:
		_timer = spawn_interval + _rng.randf_range(-0.4, 0.6)
		_spawn_enemy()

func take_damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	_hurt_flash_timer = 0.14
	modulate = Color(2.8, 0.35, 0.55, 1.0)
	queue_redraw()
	if health <= 0:
		_destruir_spawner()

func _destruir_spawner() -> void:
	var tree: SceneTree = get_tree()
	remove_from_group("spawners")
	GameState.add_score(score_value)

	# Drop raro ao destruir portal (25% de chance de soltar 1 orbe)
	if tree != null and tree.current_scene != null and _rng.randf() <= 0.25:
		var drop := Area2D.new()
		drop.set_script(DropScript)
		tree.current_scene.call_deferred("add_child", drop)
		var tipo: int = DropScript.DropType.SPREAD_BUFF if _rng.randf() < 0.25 else DropScript.DropType.ENERGY_ORB
		drop.call_deferred("setup", global_position, tipo)

	if tree != null:
		GameState.check_room_victory(tree)

	queue_free()

func _draw() -> void:
	var w: float = 34.0
	var h: float = 5.0
	var ratio: float = clampf(float(health) / float(max_health), 0.0, 1.0)
	var pos := Vector2(-w * 0.5, 20.0)
	draw_rect(Rect2(pos - Vector2(1, 1), Vector2(w + 2, h + 2)), Color(0.08, 0.05, 0.12, 0.95))
	draw_rect(Rect2(pos, Vector2(w * ratio, h)), Color(0.85, 0.25, 0.95, 1.0))

func _spawn_enemy() -> void:
	if get_tree().current_scene == null:
		return

	var enemy := CharacterBody2D.new()
	var tipo: int = _rng.randi_range(0, 1)

	var spr := Sprite2D.new()
	spr.name = "Fann"
	if tipo == 0:
		enemy.set_script(Enemy1Script)
		spr.texture = TEX_MELEE
	else:
		enemy.set_script(Enemy2Script)
		spr.texture = TEX_RANGED

	enemy.add_child(spr)

	var col := CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var rect := RectangleShape2D.new()
	rect.size = Vector2(28, 28)
	col.shape = rect
	enemy.add_child(col)

	var spawn_offset := Vector2(_rng.randf_range(-28.0, 28.0), _rng.randf_range(-28.0, 28.0))
	enemy.global_position = global_position + spawn_offset
	get_tree().current_scene.add_child(enemy)
	GameState.call_deferred("refresh_counts", get_tree())
