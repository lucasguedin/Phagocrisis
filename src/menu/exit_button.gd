
extends Button

const MENU_SCENE: String = "res://scenes/main_menu.tscn"


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var current_scene = get_tree().current_scene

	# Se estiver no menu inicial, fecha o jogo.
	if current_scene.scene_file_path == MENU_SCENE:
		get_tree().quit()
		return

	# Salva a cena e a posição do Player.
	GameState.save_current_game()

	# Despausa antes de voltar ao menu.
	get_tree().paused = false

	# Retorna ao menu inicial.
	get_tree().change_scene_to_file(MENU_SCENE)
