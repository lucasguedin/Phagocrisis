extends Node

signal stats_updated

# Última cena em que o jogador estava.
var saved_scene_path: String = ""

# Última posição do personagem.
var saved_player_position: Vector2 = Vector2.ZERO

# Indica se existe uma partida salva.
var has_saved_game: bool = false

# Atributos de sessão da sala (HUD estilo imagem de referência)
var score: int = 0
var player_level: int = 1
var enemies_alive: int = 0
var spawners_alive: int = 0
var total_spawned: int = 0

func reset_room_stats() -> void:
	score = 0
	player_level = 1
	stats_updated.emit()

func refresh_counts(tree: SceneTree) -> void:
	if tree == null:
		return
	enemies_alive = tree.get_nodes_in_group("enemies").size()
	spawners_alive = tree.get_nodes_in_group("spawners").size()
	stats_updated.emit()

func check_room_victory(tree: SceneTree) -> void:
	if tree == null:
		return
	refresh_counts(tree)
	if spawners_alive <= 0 and enemies_alive <= 0:
		var player = tree.get_first_node_in_group("player")
		if player != null and player.has_method("notify_room_cleared"):
			player.notify_room_cleared()

func add_score(points: int) -> void:
	score += points
	player_level = 1 + int(float(score) / 600.0)
	stats_updated.emit()

func save_current_game() -> void:
	var current_scene = get_tree().current_scene
	if current_scene == null:
		return

	saved_scene_path = current_scene.scene_file_path
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		saved_player_position = player.global_position
		has_saved_game = true

func continue_game() -> void:
	if not has_saved_game:
		return

	get_tree().paused = false
	var error = get_tree().change_scene_to_file(saved_scene_path)
	if error != OK:
		push_error("Não foi possível carregar a última fase.")
		return

	await get_tree().scene_changed
	var player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = saved_player_position
	else:
		push_warning("Player não encontrado na cena carregada.")
