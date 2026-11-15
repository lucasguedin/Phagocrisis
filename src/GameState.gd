extends Node

signal stats_updated

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

func resetar_run():
	score = 0
	player_level = 1
	sala_atual = 1
	vida_max_player = 6
	vida_atual_player = 6
	atp_player = 30.0
	dano_arma_player = 1
	bichos_vivos = 0
	portais_vivos = 0
	bau_vivo = 0
	stats_updated.emit()

func somar_pontos(pts: int):
	score += pts
	stats_updated.emit()


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
	if get_tree().change_scene_to_file(saved_scene_path) != OK:
		push_error("Não foi possível carregar a última fase.")
		return

	await get_tree().scene_changed
	var p = get_tree().get_first_node_in_group("player")
	if p != null:
		p.global_position = saved_player_position
