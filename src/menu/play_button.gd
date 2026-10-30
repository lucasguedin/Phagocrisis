
extends Button

@export_file("*.tscn") var game_scene_path: String


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:

	# Se estiver pausado, reinicia a fase atual.
	if get_tree().paused:

		var current_path = get_tree().current_scene.scene_file_path

		get_tree().paused = false
		GameState.has_saved_game = false

		get_tree().change_scene_to_file(current_path)
		return

	# Se estiver no menu inicial, começa um jogo novo.
	if game_scene_path.is_empty():
		push_error("Configure a cena do jogo no Inspector!")
		return

	GameState.has_saved_game = false

	get_tree().change_scene_to_file(game_scene_path)
