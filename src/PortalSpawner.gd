extends Sprite2D

const InimigoMelee = preload("res://src/enemy/Enemy1.gd")
const InimigoAtirador = preload("res://src/enemy/Enemy2.gd")
const ScriptDrop = preload("res://src/DropPickup.gd")

const TEX_MELEE = preload("res://sprites/virus_melee.png")
const TEX_RANGED = preload("res://sprites/virus_ranged.png")
const TEX_PORTAL_M = preload("res://sprites/spawner_melee.png")
const TEX_PORTAL_R = preload("res://sprites/spawner_ranged.png")

# 0 = ninho melee, 1 = ninho atirador
@export var spawner_type: int = 0
@export var tempo_entre_spawns: float = 3.8
@export var max_inimigos_sala: int = 7
@export var hp_maximo: int = 10

var hp_portal: int = 10
var tempo_piscando: float = 0.0
var timer_spawn: float = 2.0
var fase_pulso: float = 0.0
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	hp_portal = hp_maximo
	texture = TEX_PORTAL_M if spawner_type == 0 else TEX_PORTAL_R
	add_to_group("spawners")
	GameState.call_deferred("atualizar_contagem", get_tree())
	queue_redraw()


func _process(delta: float) -> void:
	if tempo_piscando > 0.0:
		tempo_piscando -= delta
		modulate = Color(2.8, 0.35, 0.55, 1.0) if tempo_piscando > 0.0 else Color.WHITE

	fase_pulso += delta * 4.0
	var esc := 1.25 + 0.12 * sin(fase_pulso)
	scale = Vector2(esc, esc)

	if get_tree().get_nodes_in_group("enemies").size() >= max_inimigos_sala:
		return

	timer_spawn -= delta
	if timer_spawn <= 0.0:
		timer_spawn = tempo_entre_spawns + rng.randf_range(-0.4, 0.6)
		_criar_inimigo()


func take_damage(dano: int) -> void:
	if hp_portal <= 0:
		return
	hp_portal -= dano
	tempo_piscando = 0.14
	modulate = Color(2.8, 0.35, 0.55, 1.0)
	queue_redraw()

	if hp_portal <= 0:
		var tree = get_tree()
		remove_from_group("spawners")
		GameState.somar_pontos(500)
		if tree != null and tree.current_scene != null and rng.randf() <= 0.25:
			var orbe = Area2D.new()
			orbe.set_script(ScriptDrop)
			tree.current_scene.call_deferred("add_child", orbe)
			orbe.call_deferred("iniciar_drop", global_position, ScriptDrop.TipoItem.ORBE_ATP)
		if tree != null:
			GameState.checar_sala_limpa(tree)
		queue_free()


func _posicao_spawn_segura(raiz: Node) -> Vector2:
	var parede := raiz.get_node_or_null("parede") as TileMapLayer
	for tentativa in range(8):
		var cand := global_position + Vector2(rng.randf_range(-28.0, 28.0), rng.randf_range(-28.0, 28.0))
		cand.x = clampf(cand.x, 56.0, 1224.0)
		cand.y = clampf(cand.y, 56.0, 664.0)
		if parede == null:
			return cand
		var cel := parede.local_to_map(parede.to_local(cand))
		var livre := true
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if parede.get_cell_source_id(cel + Vector2i(dx, dy)) != -1:
					livre = false
					break
		if livre:
			return cand
	return global_position

func _criar_inimigo():
	var raiz = get_tree().current_scene
	if raiz == null:
		return

	var novo = CharacterBody2D.new()
	var img = Sprite2D.new()
	img.name = "Fann"

	if spawner_type == 0:
		novo.set_script(InimigoMelee)
		img.texture = TEX_MELEE
	else:
		novo.set_script(InimigoAtirador)
		img.texture = TEX_RANGED

	novo.add_child(img)
	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var circ = CircleShape2D.new()
	circ.radius = 11.0
	col.shape = circ
	novo.add_child(col)

	novo.global_position = _posicao_spawn_segura(raiz)
	raiz.add_child(novo)
	GameState.call_deferred("atualizar_contagem", get_tree())

func _draw() -> void:
	var l := 34.0
	var orig := Vector2(-l * 0.5, 20.0)
	draw_rect(Rect2(orig - Vector2(1, 1), Vector2(l + 2, 7.0)), Color(0.08, 0.05, 0.12, 0.95))
	var pct := clampf(float(hp_portal) / float(hp_maximo), 0.0, 1.0)
	var cor := Color(0.95, 0.25, 0.35) if spawner_type == 0 else Color(0.35, 0.95, 0.55)
	draw_rect(Rect2(orig, Vector2(l * pct, 5.0)), cor)
