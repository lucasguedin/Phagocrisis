extends CharacterBody2D

const ScriptTiro = preload("res://src/Projectile.gd")
const ScriptDrop = preload("res://src/DropPickup.gd")

const TEX_TIRO = preload("res://sprites/shotProtaMage.png")
const TEX_PORTA_ABERTA = preload("res://sprites/door_open.png")

@export var speed: float = 220.0
@export var dash_distance: float = 96.0
@export var game_size: Vector2 = Vector2(1280.0, 720.0)
@export var pause_menu_scene: PackedScene
@export var numero_sala: int = 1
@export_file("*.tscn") var proxima_sala: String = ""

@onready var sprite: Sprite2D = $Player
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var pivo_arma: Node2D = $WeaponPivot
@onready var sprite_arma: Sprite2D = $WeaponPivot/Arma
@onready var porta_norte: Sprite2D = $"../DoorPortal"
@onready var bau_sala: Sprite2D = get_node_or_null("../TreasureChest") as Sprite2D
@onready var camera_sala: Camera2D = get_node_or_null("../Camera2D") as Camera2D

@onready var barra_hp: ProgressBar = $"../HUD/BarraHP"
@onready var txt_hp: Label = $"../HUD/TxtHP"
@onready var barra_atp: ProgressBar = $"../HUD/BarraATP"
@onready var txt_atp: Label = $"../HUD/TxtATP"
@onready var txt_nivel: Label = $"../HUD/TxtNivel"
@onready var txt_pontos: Label = $"../HUD/TxtPontos"
@onready var txt_objetivo: Label = $"../HUD/TxtObjetivo"
@onready var txt_aviso_centro: Label = $"../HUD/TxtAviso"
@onready var txt_dica: Label = get_node_or_null("../HUD/TxtDica") as Label
@onready var btn_pausa: Button = get_node_or_null("../HUD/BtnPausa") as Button
@onready var btn_dash: Button = get_node_or_null("../HUD/BtnDash") as Button
@onready var btn_reiniciar: Button = get_node_or_null("../HUD/BtnReiniciar") as Button

var ultima_direcao: Vector2 = Vector2.RIGHT
var dir_mira: Vector2 = Vector2.RIGHT
var dash_pendente: bool = false

var vida_max: int = 6
var vida_atual: int = 6
var atp_max: float = 30.0
var atp_atual: float = 30.0
var dano_arma: int = 1

var recarga_tiro: float = 0.0
var fila_tiros: int = 0
var atraso_rajada: float = 0.0

var invencivel_timer: float = 0.0
var recarga_dash: float = 0.0
var morto: bool = false
var porta_aberta: bool = false

# controles touch pra mobile
var dedo_mov_id: int = -1
var origem_toque_mov: Vector2 = Vector2.ZERO
var vetor_toque_mov: Vector2 = Vector2.ZERO
var dedo_mira_id: int = -1
var atirando_toque: bool = false


func _ready() -> void:
	add_to_group("player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	# se voltar pra sala 1 zera os status da run
	if numero_sala == 1:
		GameState.resetar_run()

	GameState.set_match_state(GameState.MatchState.IN_GAME)
	GameState.sala_atual = numero_sala
	vida_max = GameState.vida_max_player
	vida_atual = GameState.vida_atual_player
	atp_atual = GameState.atp_player
	dano_arma = GameState.dano_arma_player
	barra_hp.max_value = vida_max

	if btn_pausa != null:
		btn_pausa.pressed.connect(abrir_menu_pausa)
	if btn_dash != null:
		btn_dash.pressed.connect(func(): dash_pendente = true)
	if btn_reiniciar != null:
		btn_reiniciar.pressed.connect(_reiniciar_jogo)

	get_viewport().size_changed.connect(_ajustar_camera_responsiva)
	_ajustar_camera_responsiva()

	GameState.stats_updated.connect(_atualizar_hud)
	GameState.call_deferred("atualizar_contagem", get_tree())
	_atualizar_hud()


func _ajustar_camera_responsiva() -> void:
	var tam := get_viewport_rect().size
	if camera_sala != null:
		camera_sala.position = game_size * 0.5
		var zx := tam.x / game_size.x
		var zy := tam.y / game_size.y
		var z := minf(zx, zy)
		camera_sala.zoom = Vector2(z, z)

	if txt_dica != null:
		txt_dica.visible = tam.x >= 760.0 and not DisplayServer.is_touchscreen_available()


func _reiniciar_jogo() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/sala_1.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		abrir_menu_pausa()
		return

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_reiniciar_jogo()
		return

	if event is InputEventScreenTouch:
		var larg_tela := get_viewport_rect().size.x
		if event.pressed:
			if event.position.x < larg_tela * 0.48 and dedo_mov_id == -1:
				dedo_mov_id = event.index
				origem_toque_mov = event.position
				vetor_toque_mov = Vector2.ZERO
			elif dedo_mira_id == -1:
				dedo_mira_id = event.index
				atirando_toque = true
				_atualizar_mira_por_tela(event.position)
		else:
			if event.index == dedo_mov_id:
				dedo_mov_id = -1
				vetor_toque_mov = Vector2.ZERO
			elif event.index == dedo_mira_id:
				dedo_mira_id = -1
				atirando_toque = false
		return

	if event is InputEventScreenDrag:
		if event.index == dedo_mov_id:
			var delta_toque: Vector2 = event.position - origem_toque_mov
			if delta_toque.length() > 10.0:
				vetor_toque_mov = (delta_toque / 55.0).limit_length(1.0)
			else:
				vetor_toque_mov = Vector2.ZERO
		elif event.index == dedo_mira_id:
			_atualizar_mira_por_tela(event.position)
		return

	if event.is_action_pressed(&"dash"):
		dash_pendente = true

	if event.is_action_pressed(&"shoot") and recarga_tiro <= 0.0 and fila_tiros <= 0:
		_iniciar_rajada()

func _atualizar_mira_por_tela(pos_tela: Vector2) -> void:
	var mundo := get_canvas_transform().affine_inverse() * pos_tela
	var diff := mundo - global_position
	if diff.length() > 1.0:
		dir_mira = diff.normalized()

func abrir_menu_pausa() -> void:
	if pause_menu_scene == null or get_tree().paused:
		return
	var camada := CanvasLayer.new()
	camada.process_mode = Node.PROCESS_MODE_ALWAYS
	camada.layer = 10
	get_tree().current_scene.add_child(camada)

	var menu := pause_menu_scene.instantiate() as Control
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	camada.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	GameState.set_match_state(GameState.MatchState.PAUSED)
	get_tree().paused = true


func _physics_process(delta: float) -> void:
	if morto:
		return

	if invencivel_timer > 0.0:
		invencivel_timer -= delta
		sprite.modulate = Color(2.2, 0.35, 0.35, 0.65) if int(invencivel_timer * 20.0) % 2 == 0 else Color(1, 1, 1, 0.9)
	else:
		sprite.modulate = Color.WHITE

	if recarga_dash > 0.0:
		recarga_dash -= delta

	if atp_atual < atp_max:
		atp_atual = minf(atp_max, atp_atual + 4.5 * delta)
		_atualizar_hud()

	var mov := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if vetor_toque_mov.length() > mov.length():
		mov = vetor_toque_mov

	if mov != Vector2.ZERO:
		ultima_direcao = mov.normalized()

	if dash_pendente:
		dash_pendente = false
		_tentar_dash()

	velocity = mov * speed
	move_and_slide()

	# bau da sala 4 recupera vida e dobra o dano
	if bau_sala != null and is_instance_valid(bau_sala):
		if global_position.distance_to(bau_sala.global_position) <= 42.0:
			_abrir_bau()

	if porta_aberta and not proxima_sala.is_empty():
		if global_position.distance_to(porta_norte.global_position) <= 50.0:
			GameState.vida_max_player = vida_max
			GameState.vida_atual_player = vida_atual
			GameState.atp_player = atp_atual
			GameState.dano_arma_player = dano_arma
			get_tree().change_scene_to_file(proxima_sala)
			return

	if invencivel_timer <= 0.0:
		for i in range(get_slide_collision_count()):
			var col = get_slide_collision(i)
			if col != null:
				var obj = col.get_collider() as Node2D
				if obj != null and obj.is_in_group("enemies"):
					take_damage(1, obj.global_position)
					break

	var manche := Input.get_vector(&"aim_left", &"aim_right", &"aim_up", &"aim_down")
	if manche.length() >= 0.25:
		dir_mira = manche.normalized()
	elif dedo_mira_id == -1 and dedo_mov_id == -1:
		var diff_mouse = get_global_mouse_position() - global_position
		if diff_mouse.length() > 1.0:
			dir_mira = diff_mouse.normalized()

	var ang: float = dir_mira.angle()
	pivo_arma.rotation = ang
	sprite_arma.flip_v = absf(ang) > PI * 0.5
	sprite.flip_h = dir_mira.x < 0.0

	if recarga_tiro > 0.0:
		recarga_tiro -= delta

	if fila_tiros > 0:
		atraso_rajada -= delta
		if atraso_rajada <= 0.0:
			atraso_rajada = 0.065
			fila_tiros -= 1
			_instanciar_bala()
	elif (Input.is_action_pressed(&"shoot") or atirando_toque) and recarga_tiro <= 0.0:
		_iniciar_rajada()

	queue_redraw()


func _abrir_bau():
	bau_sala.remove_from_group("treasure")
	bau_sala.queue_free()
	bau_sala = null

	vida_max += 2
	vida_atual = vida_max
	barra_hp.max_value = vida_max
	atp_atual = atp_max
	dano_arma = 2

	GameState.vida_max_player = vida_max
	GameState.vida_atual_player = vida_atual
	GameState.atp_player = atp_atual
	GameState.dano_arma_player = dano_arma
	GameState.unlock_adaptation(&"lipid_membrane")
	GameState.somar_pontos(400)
	GameState.checar_sala_limpa(get_tree())
	_atualizar_hud()
	queue_redraw()

func _iniciar_rajada():
	recarga_tiro = 0.36
	fila_tiros = 2
	atraso_rajada = 0.065
	_instanciar_bala()

func _instanciar_bala():
	var b = Area2D.new()
	b.set_script(ScriptTiro)

	var s = Sprite2D.new()
	s.texture = TEX_TIRO
	s.scale = Vector2(0.95, 1.15)
	b.add_child(s)

	var c = CollisionShape2D.new()
	var forma = CircleShape2D.new()
	forma.radius = 6.0
	c.shape = forma
	b.add_child(c)

	var cor_tiro = Color(0.45, 1.0, 0.55, 1.0) if dano_arma > 1 else Color.WHITE
	get_tree().current_scene.add_child(b)
	b.disparar(sprite_arma.global_position + dir_mira * 12.0, dir_mira, cor_tiro, dano_arma)


func _tentar_dash() -> bool:
	if dash_distance <= 0.0 or morto or atp_atual < 6.0 or recarga_dash > 0.0:
		return false
	if collision_shape.shape == null:
		return false

	var passo_dash: Vector2 = ultima_direcao.normalized() * dash_distance
	if _dash_fora_dos_limites(passo_dash):
		return false

	if test_move(global_transform, passo_dash):
		passo_dash *= 0.5

	atp_atual -= 6.0
	invencivel_timer = 0.25
	recarga_dash = 0.35
	move_and_collide(passo_dash)
	_atualizar_hud()
	return true

func _dash_fora_dos_limites(movimento: Vector2) -> bool:
	var ret_local: Rect2 = collision_shape.shape.get_rect()
	var ret_atual: Rect2 = collision_shape.global_transform * ret_local
	var tela := Rect2(Vector2.ZERO, game_size)

	if not tela.encloses(ret_atual):
		return true
	var ret_final := Rect2(ret_atual.position + movimento, ret_atual.size)
	return not tela.encloses(ret_final)


func take_damage(qtd: int = 1, de_onde: Vector2 = Vector2.ZERO):
	if morto or invencivel_timer > 0.0:
		return

	vida_atual = maxi(0, vida_atual - qtd)
	invencivel_timer = 0.70

	if de_onde != Vector2.ZERO:
		move_and_collide((global_position - de_onde).normalized() * 18.0)

	_atualizar_hud()
	queue_redraw()

	if vida_atual <= 0:
		morto = true
		GameState.set_match_state(GameState.MatchState.GAME_OVER)
		sprite.modulate = Color(0.5, 0.1, 0.1, 0.8)
		txt_aviso_centro.text = "GAME OVER\nAperte [R] ou toque abaixo para tentar de novo"
		txt_aviso_centro.modulate = Color(1.0, 0.25, 0.25)
		txt_aviso_centro.visible = true
		if btn_reiniciar != null:
			btn_reiniciar.visible = true

func pegar_drop(tipo: int):
	if tipo == ScriptDrop.TipoItem.CURA_FORTE:
		vida_atual = mini(vida_max, vida_atual + 2)
		atp_atual = atp_max
		GameState.somar_pontos(150)
	else:
		vida_atual = mini(vida_max, vida_atual + 1)
		atp_atual = minf(atp_max, atp_atual + 8.0)
		GameState.somar_pontos(50)
	_atualizar_hud()
	queue_redraw()


func destravar_porta():
	if morto or porta_aberta:
		return
	porta_aberta = true

	if numero_sala < GameState.total_salas:
		GameState.set_match_state(GameState.MatchState.LEVEL_CLEAR)
		porta_norte.texture = TEX_PORTA_ABERTA
		porta_norte.modulate = Color(0.6, 1.4, 0.7, 1.0)
		var nome_prox = "SALA %d/5" % (numero_sala + 1)
		if numero_sala == 3:
			nome_prox = "SALA DO TESOURO"
		elif numero_sala == 4:
			nome_prox = "SALA DO BOSS"
		txt_aviso_centro.text = "SALA %d/5 LIMPA!\nEntre na porta acima para ir para a %s" % [numero_sala, nome_prox]
		txt_aviso_centro.modulate = Color(0.35, 1.0, 0.45)
		txt_aviso_centro.visible = true
	else:
		GameState.set_match_state(GameState.MatchState.VICTORY)
		txt_aviso_centro.text = "BACTERIOFAGO DERROTADO! FASE CONCLUIDA!\nAperte [R] ou toque abaixo para jogar novamente"
		txt_aviso_centro.modulate = Color(0.35, 1.0, 0.35)
		txt_aviso_centro.visible = true
		if btn_reiniciar != null:
			btn_reiniciar.visible = true

func _atualizar_hud():
	barra_hp.value = vida_atual
	txt_hp.text = "%d/%d" % [vida_atual, vida_max]
	barra_atp.value = atp_atual
	txt_atp.text = "%d/%d" % [int(atp_atual), int(atp_max)]
	txt_nivel.text = "LEVEL: %d   SALA: %d/%d" % [GameState.player_level, numero_sala, GameState.total_salas]
	txt_pontos.text = "SCORE: %d" % GameState.score
	if numero_sala == 4:
		txt_objetivo.text = "TESOURO: %d" % GameState.bau_vivo
	else:
		txt_objetivo.text = "PORTAIS: %d   INIMIGOS: %d" % [GameState.portais_vivos, GameState.bichos_vivos]
	GameState.player_health_changed.emit(float(vida_atual), float(vida_max))
	GameState.player_atp_changed.emit(atp_atual, atp_max)

func _draw() -> void:
	var l := 34.0
	var p := Vector2(-l * 0.5, 20.0)
	draw_rect(Rect2(p - Vector2(1, 1), Vector2(l + 2, 7.0)), Color(0.08, 0.08, 0.12, 0.95))
	var pct := clampf(float(vida_atual) / float(vida_max), 0.0, 1.0)
	var cor := Color(0.95, 0.22, 0.22) if pct <= 0.4 else Color(0.25, 0.95, 0.35)
	draw_rect(Rect2(p, Vector2(l * pct, 5.0)), cor)
