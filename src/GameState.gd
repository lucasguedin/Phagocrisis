extends Node

enum MatchState { SPLASH, MAIN_MENU, IN_GAME, PAUSED, LEVEL_CLEAR, GAME_OVER, VICTORY }

signal stats_updated
signal state_changed(new_state: MatchState)
signal player_health_changed(current_hp: float, max_hp: float)
signal player_atp_changed(current_atp: float, max_atp: float)
signal biomass_changed(new_score: int)
signal receptors_changed(count: int)
signal temporary_buff_updated(buff_type: StringName, time_left: float)
signal mitotic_adaptation_unlocked(adaptation_id: StringName)

var current_state: MatchState = MatchState.MAIN_MENU
var current_level: int = 1
var biomass_score: int = 0
var molecular_receptors: int = 0
var run_elapsed_time: float = 0.0

var active_adaptations: Dictionary = {
	&"lipid_membrane": false,
	&"super_mitochondria": false,
	&"strong_pseudopods": false,
	&"digestive_gland": false
}

var saved_scene_path: String = ""
var saved_player_position: Vector2 = Vector2.ZERO
var has_saved_game: bool = false

var score: int = 0
var player_level: int = 1
var sala_atual: int = 1
var total_salas: int = 5

# guarda os status do player pra passar de uma cena pra outra
var vida_max_player: int = 6
var vida_atual_player: int = 6
var atp_player: float = 30.0
var dano_arma_player: int = 1

var bichos_vivos: int = 0
var portais_vivos: int = 0
var bau_vivo: int = 0

func _process(delta: float) -> void:
	if current_state == MatchState.IN_GAME and not get_tree().paused:
		run_elapsed_time += delta

func set_match_state(novo_estado: MatchState) -> void:
	if current_state == novo_estado:
		return
	current_state = novo_estado
	state_changed.emit(current_state)

func reset_run_state() -> void:
	resetar_run()

func resetar_run():
	score = 0
	biomass_score = 0
	molecular_receptors = 0
	run_elapsed_time = 0.0
	player_level = 1
	current_level = 1
	sala_atual = 1
	vida_max_player = 6
	vida_atual_player = 6
	atp_player = 30.0
	dano_arma_player = 1
	bichos_vivos = 0
	portais_vivos = 0
	bau_vivo = 0
	for k in active_adaptations.keys():
		active_adaptations[k] = false
	biomass_changed.emit(biomass_score)
	receptors_changed.emit(molecular_receptors)
	stats_updated.emit()

func add_biomass(qtd: int) -> void:
	somar_pontos(qtd)

func somar_pontos(pts: int):
	score += pts
	biomass_score = score
	biomass_changed.emit(biomass_score)
	stats_updated.emit()

func add_receptor(qtd: int = 1) -> void:
	molecular_receptors = clampi(molecular_receptors + qtd, 0, 3)
	receptors_changed.emit(molecular_receptors)
	stats_updated.emit()

func unlock_adaptation(id_adaptacao: StringName) -> void:
	if active_adaptations.has(id_adaptacao):
		active_adaptations[id_adaptacao] = true
		mitotic_adaptation_unlocked.emit(id_adaptacao)
		stats_updated.emit()

func update_temporary_buff(tipo_buff: StringName, tempo_restante: float) -> void:
	temporary_buff_updated.emit(tipo_buff, tempo_restante)


func atualizar_contagem(arvore: SceneTree) -> void:
	if arvore == null:
		return
	bichos_vivos = arvore.get_nodes_in_group("enemies").size()
	portais_vivos = arvore.get_nodes_in_group("spawners").size()
	bau_vivo = arvore.get_nodes_in_group("treasure").size()
	stats_updated.emit()

func checar_sala_limpa(arvore: SceneTree) -> void:
	if arvore == null:
		return
	atualizar_contagem(arvore)
	if portais_vivos == 0 and bichos_vivos == 0 and bau_vivo == 0:
		var p = arvore.get_first_node_in_group("player")
		if p != null and p.has_method("destravar_porta"):
			p.destravar_porta()


func save_current_game() -> void:
	var cena = get_tree().current_scene
	if cena != null:
		saved_scene_path = cena.scene_file_path
		var p = get_tree().get_first_node_in_group("player")
		if p != null:
			saved_player_position = p.global_position
			has_saved_game = true

func continue_game() -> void:
	if not has_saved_game:
		return
	get_tree().paused = false
	set_match_state(MatchState.IN_GAME)
	if get_tree().change_scene_to_file(saved_scene_path) != OK:
		push_error("Não foi possível carregar a última fase.")
		return

	await get_tree().scene_changed
	var p = get_tree().get_first_node_in_group("player")
	if p != null:
		p.global_position = saved_player_position
