extends Control

@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton
@onready var play_button: Button = $CenterContainer/VBoxContainer/PlayButton
@onready var title_label: Label = get_node_or_null("CenterContainer/VBoxContainer/TitleLabel") as Label
@onready var vbox: VBoxContainer = get_node_or_null("CenterContainer/VBoxContainer") as VBoxContainer

var is_pause_menu: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	is_pause_menu = get_parent() is CanvasLayer
	if not is_pause_menu:
		continue_button.visible = GameState.has_saved_game

	if is_pause_menu:
		play_button.text = "Reiniciar fase"
	else:
		play_button.text = "Jogar"

	continue_button.pressed.connect(_on_continue_pressed)
	get_viewport().size_changed.connect(_ajustar_layout_menu)
	_ajustar_layout_menu()

func _ajustar_layout_menu() -> void:
	var tam := get_viewport_rect().size
	if title_label != null:
		var fonte_tam := clampi(int(minf(tam.x * 0.11, tam.y * 0.195)), 48, 140)
		title_label.add_theme_font_size_override("font_size", fonte_tam)
	if vbox != null:
		var sep := clampi(int(tam.y * 0.025), 8, 20)
		vbox.add_theme_constant_override("separation", sep)

func _on_continue_pressed() -> void:
	if is_pause_menu:
		get_tree().paused = false
		GameState.set_match_state(GameState.MatchState.IN_GAME)
		get_parent().queue_free()
	else:
		GameState.continue_game()
