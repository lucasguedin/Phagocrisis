
extends Node

# Última cena em que o jogador estava.
var saved_scene_path: String = ""

# Última posição do personagem.
var saved_player_position: Vector2 = Vector2.ZERO

# Indica se existe uma partida salva.
var has_saved_game: bool = false


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

	# Espera a cena ser carregada antes de procurar o Player.
	await get_tree().scene_changed

	var player = get_tree().get_first_node_in_group("player")

	if player != null:
		player.global_position = saved_player_position
	else:
		push_warning("Player não encontrado na cena carregada.")
