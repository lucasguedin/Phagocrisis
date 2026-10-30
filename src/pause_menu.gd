
extends Control

@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton
@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton

var is_pause_menu: bool = false

# menu backend
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# O menu de pausa é filho de um CanvasLayer.
	is_pause_menu = get_parent() is CanvasLayer
	if not is_pause_menu:
		continue_button.visible = GameState.has_saved_game
	
	if is_pause_menu:
		play_button.text = "Reiniciar fase"
	else:
		play_button.text = "Jogar"

	continue_button.pressed.connect(_on_continue_pressed)


func _on_continue_pressed() -> void:

	if is_pause_menu:
		# Fecha somente o menu de pausa.
		get_tree().paused = false
		get_parent().queue_free()

	else:
		# No menu inicial, recupera a partida salva.
		GameState.continue_game()
