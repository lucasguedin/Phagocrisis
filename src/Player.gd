extends CharacterBody2D

const ProjectileScript = preload("res://src/Projectile.gd")
const DropScript = preload("res://src/DropPickup.gd")
const PortalSpawnerScript = preload("res://src/PortalSpawner.gd")
const Enemy1Script = preload("res://src/enemy/Enemy1.gd")
const Enemy2Script = preload("res://src/enemy/Enemy2.gd")
const BossScript = preload("res://src/enemy/Enemy3.gd")

const TEX_PROTA = preload("res://sprites/prota.png")
const TEX_CANN = preload("res://sprites/cann.png")
const TEX_SHOT = preload("res://sprites/shotProtaMage.png")
const TEX_MELEE = preload("res://sprites/virus_melee.png")
const TEX_RANGED = preload("res://sprites/virus_ranged.png")
const TEX_BOSS = preload("res://sprites/boss_bacteriofago.png")
const TEX_CHEST = preload("res://sprites/chest_treasure.png")
const TEX_DOOR_CLOSED = preload("res://sprites/door_closed.png")
const TEX_DOOR_OPEN = preload("res://sprites/door_open.png")

@export var speed: float = 220.0
@export var dash_distance: float = 96.0
@export var game_size: Vector2 = Vector2(1280.0, 720.0)
@export var pause_menu_scene: PackedScene

@onready var sprite: Sprite2D = $Player
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Atributos vitais (HP 6/6, ATP 30/30)
var max_hp: int = 6
var hp: int = 6
var max_atp: float = 30.0
var atp: float = 30.0
var projectile_damage: int = 1

# Combate e Mira 360° (3 tiros em linha reta por clique)
var aim_direction: Vector2 = Vector2.RIGHT
var ultima_direcao: Vector2 = Vector2.RIGHT
var _shoot_cooldown: float = 0.0
var _burst_remaining: int = 0
var _burst_step_timer: float = 0.0
var _invuln_timer: float = 0.0
var _dash_timer: float = 0.0
var _is_dead: bool = false
var _room_cleared: bool = false
var _transition_lock: float = 0.0

# Nós visuais acoplados (arma, porta, tesouro e HUD frugal)
var weapon_pivot: Node2D
var weapon_sprite: Sprite2D
var door_sprite: Sprite2D
var chest_node: Sprite2D
var hud_hp_bar: ProgressBar
var hud_hp_label: Label
var hud_atp_bar: ProgressBar
var hud_atp_label: Label
var hud_lv_label: Label
var hud_score_label: Label
var hud_obj_label: Label
var hud_status_label: Label
var hud_slot_bgs: Array = []
var hud_slot_icons: Array = []

func _ready() -> void:
	add_to_group("player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	GameState.reset_room_stats()

	if sprite != null:
		if sprite.position != Vector2.ZERO:
			global_position = sprite.position
			sprite.position = Vector2.ZERO
		sprite.scale = Vector2(1.6, 1.6)
	if collision_shape != null and collision_shape.position != Vector2.ZERO:
		collision_shape.position = Vector2.ZERO

	_setup_weapon_node()
	_setup_frugal_hud()
	GameState.stats_updated.connect(_update_hud)
	call_deferred("_iniciar_primeira_sala")

func _iniciar_primeira_sala() -> void:
	_setup_door_node()
	_carregar_sala(1)

func _setup_door_node() -> void:
	if get_tree().current_scene == null:
		return
	door_sprite = Sprite2D.new()
	door_sprite.name = "DoorPortal"
	door_sprite.texture = TEX_DOOR_CLOSED
	door_sprite.scale = Vector2(2.0, 1.5)
	door_sprite.position = Vector2(640.0, 36.0)
	get_tree().current_scene.add_child(door_sprite)

func _setup_weapon_node() -> void:
	weapon_pivot = Node2D.new()
	weapon_pivot.name = "WeaponPivot"
	add_child(weapon_pivot)

	weapon_sprite = Sprite2D.new()
	weapon_sprite.texture = TEX_CANN
	weapon_sprite.position = Vector2(18.0, 2.0)
	weapon_sprite.scale = Vector2(0.85, 0.85)
	weapon_pivot.add_child(weapon_sprite)

func _setup_frugal_hud() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "FrugalHUD"
	add_child(canvas)

	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(root)

	# Moldura do Retrato do Protagonista
	var portrait_bg := ColorRect.new()
	portrait_bg.position = Vector2(16, 16)
	portrait_bg.size = Vector2(68, 68)
	portrait_bg.color = Color(0.12, 0.14, 0.22, 0.95)
	root.add_child(portrait_bg)

	var portrait_tex := TextureRect.new()
	portrait_tex.texture = TEX_PROTA
	portrait_tex.position = Vector2(22, 22)
	portrait_tex.size = Vector2(56, 56)
	portrait_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	root.add_child(portrait_tex)

	# Barra Vermelha de HP (6/6)
	hud_hp_bar = ProgressBar.new()
	hud_hp_bar.position = Vector2(92, 16)
	hud_hp_bar.size = Vector2(180, 24)
	hud_hp_bar.max_value = max_hp
	hud_hp_bar.value = hp
	hud_hp_bar.show_percentage = false
	var hp_bg := StyleBoxFlat.new()
	hp_bg.bg_color = Color(0.15, 0.15, 0.22, 0.95)
	hp_bg.set_border_width_all(2)
	hp_bg.border_color = Color(0.75, 0.75, 0.82, 1.0)
	var hp_fg := StyleBoxFlat.new()
	hp_fg.bg_color = Color(0.88, 0.18, 0.22, 1.0)
	hud_hp_bar.add_theme_stylebox_override("background", hp_bg)
	hud_hp_bar.add_theme_stylebox_override("fill", hp_fg)
	root.add_child(hud_hp_bar)

	hud_hp_label = Label.new()
	hud_hp_label.position = Vector2(92, 16)
	hud_hp_label.size = Vector2(180, 24)
	hud_hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud_hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hud_hp_label.text = "6/6"
	root.add_child(hud_hp_label)

	# Barra Azul de ATP / Energia (30/30)
	hud_atp_bar = ProgressBar.new()
	hud_atp_bar.position = Vector2(92, 46)
	hud_atp_bar.size = Vector2(180, 24)
	hud_atp_bar.max_value = max_atp
	hud_atp_bar.value = atp
	hud_atp_bar.show_percentage = false
	var atp_fg := StyleBoxFlat.new()
	atp_fg.bg_color = Color(0.15, 0.58, 0.92, 1.0)
	hud_atp_bar.add_theme_stylebox_override("background", hp_bg)
	hud_atp_bar.add_theme_stylebox_override("fill", atp_fg)
	root.add_child(hud_atp_bar)

	hud_atp_label = Label.new()
	hud_atp_label.position = Vector2(92, 46)
	hud_atp_label.size = Vector2(180, 24)
	hud_atp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud_atp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hud_atp_label.text = "30/30"
	root.add_child(hud_atp_label)

	# Labels de Nível da Fase (estático na fase) e SCORE
	hud_lv_label = Label.new()
	hud_lv_label.position = Vector2(16, 86)
	hud_lv_label.text = "LEVEL: 1   SALA: 1/5"
	root.add_child(hud_lv_label)

	hud_score_label = Label.new()
	hud_score_label.position = Vector2(190, 86)
	hud_score_label.text = "SCORE: 0"
	root.add_child(hud_score_label)

	# Quadrados Laterais Dinâmicos: mostram APENAS os inimigos presentes na sala atual
	hud_slot_bgs.clear()
	hud_slot_icons.clear()
	for i in range(3):
		var slot_bg := ColorRect.new()
		slot_bg.position = Vector2(16 + i * 38, 114)
		slot_bg.size = Vector2(32, 32)
		slot_bg.color = Color(0.14, 0.14, 0.20, 0.9)
		slot_bg.clip_contents = true
		root.add_child(slot_bg)

		var slot_icon := TextureRect.new()
		slot_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot_icon.position = Vector2(2, 2)
		slot_icon.size = Vector2(28, 28)
		slot_bg.add_child(slot_icon)

		hud_slot_bgs.append(slot_bg)
		hud_slot_icons.append(slot_icon)

	hud_obj_label = Label.new()
	hud_obj_label.position = Vector2(16, 152)
	hud_obj_label.text = "PORTAIS: 2   INIMIGOS: 4"
	hud_obj_label.modulate = Color(1.0, 0.85, 0.35, 1.0)
	root.add_child(hud_obj_label)

	# Dica de Controles e Status Central
	var help_lbl := Label.new()
	help_lbl.position = Vector2(16, 688)
	help_lbl.text = "[WASD] Mover | [Clique/Espaço] 3 Tiros em Linha Reta | [E/RMB] Dash | [Porta Norte] Próxima Sala | [R] Reiniciar"
	help_lbl.modulate = Color(0.9, 0.9, 0.9, 0.85)
	root.add_child(help_lbl)

	hud_status_label = Label.new()
	hud_status_label.position = Vector2(240, 290)
	hud_status_label.size = Vector2(800, 110)
	hud_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hud_status_label.add_theme_font_size_override("font_size", 28)
	hud_status_label.visible = false
	root.add_child(hud_status_label)

func _atualizar_icones_inimigos_da_sala(num_sala: int) -> void:
	var inimigos_na_sala: Array = []
	if num_sala == 1:
		inimigos_na_sala = [TEX_MELEE]
	elif num_sala == 2:
		inimigos_na_sala = [TEX_RANGED]
	elif num_sala == 3:
		inimigos_na_sala = [TEX_MELEE, TEX_RANGED]
	elif num_sala == 4:
		inimigos_na_sala = []
	elif num_sala == 5:
		inimigos_na_sala = [TEX_MELEE, TEX_RANGED, TEX_BOSS]

	for i in range(hud_slot_bgs.size()):
		var bg: ColorRect = hud_slot_bgs[i]
		var ic: TextureRect = hud_slot_icons[i]
		if i < inimigos_na_sala.size():
			bg.visible = true
			ic.texture = inimigos_na_sala[i]
		else:
			bg.visible = false

func _limpar_entidades_da_sala() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	for node in get_tree().get_nodes_in_group("spawners"):
		node.remove_from_group("spawners")
		node.queue_free()
	for node in get_tree().get_nodes_in_group("enemies"):
		node.remove_from_group("enemies")
		node.queue_free()
	for node in get_tree().get_nodes_in_group("treasure"):
		node.remove_from_group("treasure")
		node.queue_free()
	for child in scene.get_children():
		if child is Area2D and child != self:
			child.queue_free()

func _carregar_sala(num_sala: int) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return

	_limpar_entidades_da_sala()
	GameState.current_room = num_sala
	_room_cleared = false
	_burst_remaining = 0
	_transition_lock = 0.65
	hud_status_label.visible = false
	_atualizar_icones_inimigos_da_sala(num_sala)

	if door_sprite != null:
		door_sprite.visible = (num_sala < GameState.max_rooms)
		door_sprite.texture = TEX_DOOR_CLOSED
		door_sprite.modulate = Color.WHITE

	# Posiciona o jogador na entrada sul da nova sala (ou no centro na Sala 1)
	if num_sala == 1:
		global_position = Vector2(560.0, 380.0)
	else:
		global_position = Vector2(640.0, 610.0)

	if num_sala == 1:
		# Sala 1: SÓ MELEE (Spawners só Melee + Inimigos só Melee)
		_criar_spawner(0, Vector2(180, 260))
		_criar_spawner(0, Vector2(1100, 560))
		_criar_inimigo(0, Vector2(920, 220))
		_criar_inimigo(0, Vector2(900, 480))
		_criar_inimigo(0, Vector2(1040, 340))
	elif num_sala == 2:
		# Sala 2: SÓ ATIRADOR (Spawners só Atirador + Inimigos só Atirador)
		_criar_spawner(1, Vector2(160, 260))
		_criar_spawner(1, Vector2(1130, 140))
		_criar_inimigo(1, Vector2(340, 240))
		_criar_inimigo(1, Vector2(940, 240))
		_criar_inimigo(1, Vector2(1020, 460))
	elif num_sala == 3:
		# Sala 3: OS DOIS (Spawner Melee + Spawner Atirador + Inimigos Melee e Atirador)
		_criar_spawner(0, Vector2(160, 260))
		_criar_spawner(1, Vector2(1130, 140))
		_criar_spawner(0, Vector2(160, 560))
		_criar_spawner(1, Vector2(1130, 560))
		_criar_inimigo(0, Vector2(460, 220))
		_criar_inimigo(0, Vector2(820, 220))
		_criar_inimigo(1, Vector2(240, 360))
		_criar_inimigo(1, Vector2(1040, 360))
	elif num_sala == 4:
		# Sala 4: Sala do Tesouro (Baú Biológico no centro, sem inimigos)
		_criar_bau_tesouro(Vector2(640.0, 350.0))
		hud_status_label.text = "SALA DO TESOURO!\nEncoste na Cápsula Dourada para melhorar o Fagócito!"
		hud_status_label.modulate = Color(0.35, 0.95, 1.0)
		hud_status_label.visible = true
	elif num_sala == 5:
		# Sala 5: TODOS + BACTERIÓFAGO (Spawner Melee + Spawner Atirador + Melee + Atirador + Boss)
		_criar_spawner(0, Vector2(160, 260))
		_criar_spawner(1, Vector2(1120, 260))
		_criar_inimigo(2, Vector2(640, 200)) # Boss Bacteriófago
		_criar_inimigo(0, Vector2(340, 240))
		_criar_inimigo(1, Vector2(940, 240))

	GameState.call_deferred("refresh_counts", get_tree())

func _criar_spawner(tipo_spawner: int, pos: Vector2) -> void:
	var sp := Sprite2D.new()
	sp.position = pos
	sp.set_script(PortalSpawnerScript)
	get_tree().current_scene.add_child(sp)
	sp.setup_spawner(tipo_spawner)

func _criar_inimigo(tipo: int, pos: Vector2) -> void:
	var enemy := CharacterBody2D.new()
	var spr := Sprite2D.new()
	spr.name = "Fann"
	if tipo == 0:
		enemy.set_script(Enemy1Script)
		spr.texture = TEX_MELEE
	elif tipo == 1:
		enemy.set_script(Enemy2Script)
		spr.texture = TEX_RANGED
	else:
		enemy.set_script(BossScript)
		spr.texture = TEX_BOSS
	enemy.add_child(spr)

	var col := CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var rect := RectangleShape2D.new()
	rect.size = Vector2(44, 44) if tipo == 2 else Vector2(28, 28)
	col.shape = rect
	enemy.add_child(col)

	enemy.position = pos
	get_tree().current_scene.add_child(enemy)

func _criar_bau_tesouro(pos: Vector2) -> void:
	chest_node = Sprite2D.new()
	chest_node.name = "TreasureChest"
	chest_node.texture = TEX_CHEST
	chest_node.scale = Vector2(1.9, 1.9)
	chest_node.position = pos
	chest_node.add_to_group("treasure")
	get_tree().current_scene.add_child(chest_node)

func _coletar_bau_tesouro() -> void:
	if chest_node == null or not is_instance_valid(chest_node):
		return
	chest_node.remove_from_group("treasure")
	chest_node.queue_free()
	chest_node = null

	# Aplica upgrade do Tesouro antes do Boss
	max_hp += 2
	hp = max_hp
	hud_hp_bar.max_value = max_hp
	atp = max_atp
	projectile_damage = 2
	GameState.add_score(400)
	GameState.check_room_victory(get_tree())
	_update_hud()
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_P or event.keycode == KEY_ESCAPE:
			abrir_menu_pausa()
			return
		if event.keycode == KEY_R:
			get_tree().paused = false
			get_tree().reload_current_scene()
			return
		if event.keycode == KEY_E or event.keycode == KEY_SHIFT:
			_tentar_dash()
		if event.keycode == KEY_SPACE and _shoot_cooldown <= 0.0 and _burst_remaining <= 0:
			_iniciar_sequencia_3_tiros()

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_tentar_dash()
		elif event.button_index == MOUSE_BUTTON_LEFT and _shoot_cooldown <= 0.0 and _burst_remaining <= 0:
			_iniciar_sequencia_3_tiros()

func abrir_menu_pausa() -> void:
	if pause_menu_scene == null or get_tree().paused:
		return
	var overlay_layer := CanvasLayer.new()
	overlay_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay_layer.layer = 10
	get_tree().current_scene.add_child(overlay_layer)

	var menu := pause_menu_scene.instantiate() as Control
	menu.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay_layer.add_child(menu)
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	if _transition_lock > 0.0:
		_transition_lock -= delta

	if _invuln_timer > 0.0:
		_invuln_timer -= delta
		var blink: bool = int(_invuln_timer * 20.0) % 2 == 0
		sprite.modulate = Color(2.2, 0.35, 0.35, 0.65) if blink else Color(1.0, 1.0, 1.0, 0.9)
	else:
		sprite.modulate = Color.WHITE

	if _dash_timer > 0.0:
		_dash_timer -= delta

	# Regenera ATP continuamente
	if atp < max_atp:
		atp = minf(max_atp, atp + 4.5 * delta)
		_update_hud()

	# Leitura de movimento (Teclado WASD/Setas + Analógico Esquerdo)
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT) or Input.get_joy_axis(0, JOY_AXIS_LEFT_X) < -0.25:
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT) or Input.get_joy_axis(0, JOY_AXIS_LEFT_X) > 0.25:
		direction.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) < -0.25:
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) or Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) > 0.25:
		direction.y += 1.0

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		ultima_direcao = direction

	velocity = direction * speed
	move_and_slide()

	# Verifica se encostou no Baú de Tesouro (Sala 4)
	if chest_node != null and is_instance_valid(chest_node):
		if global_position.distance_to(chest_node.global_position) <= 42.0:
			_coletar_bau_tesouro()

	# Verifica se entrou na Porta aberta no Norte para ir direto à próxima sala (sem corredor)
	if _room_cleared and _transition_lock <= 0.0 and GameState.current_room < GameState.max_rooms:
		if door_sprite != null and global_position.distance_to(door_sprite.global_position) <= 50.0:
			_carregar_sala(GameState.current_room + 1)
			return

	# Verifica se encostou em algum inimigo durante o movimento
	if _invuln_timer <= 0.0:
		for i in range(get_slide_collision_count()):
			var col := get_slide_collision(i)
			if col != null:
				var collider := col.get_collider() as Node2D
				if collider != null and collider.is_in_group("enemies"):
					take_damage(1, collider.global_position)
					break

	# Atualiza Mira 360° da arma (Mouse ou Stick Direito)
	_atualizar_mira_e_arma()

	# Processa sequência de 3 tiros em linha reta por clique
	if _shoot_cooldown > 0.0:
		_shoot_cooldown -= delta

	if _burst_remaining > 0:
		_burst_step_timer -= delta
		if _burst_step_timer <= 0.0:
			_burst_step_timer = 0.065
			_burst_remaining -= 1
			_disparar_tiro_reto()
	else:
		var quer_atirar_cont: bool = (
			Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
			or Input.is_key_pressed(KEY_SPACE)
			or Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT) > 0.3
		)
		if quer_atirar_cont and _shoot_cooldown <= 0.0:
			_iniciar_sequencia_3_tiros()

	queue_redraw()

func _atualizar_mira_e_arma() -> void:
	var joy_aim := Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
	if joy_aim.length() >= 0.25:
		aim_direction = joy_aim.normalized()
	else:
		var to_mouse := get_global_mouse_position() - global_position
		if to_mouse.length() > 1.0:
			aim_direction = to_mouse.normalized()

	var ang := aim_direction.angle()
	weapon_pivot.rotation = ang
	weapon_sprite.flip_v = absf(ang) > PI * 0.5
	sprite.flip_h = aim_direction.x < 0.0

func _iniciar_sequencia_3_tiros() -> void:
	_shoot_cooldown = 0.36
	_burst_remaining = 2
	_burst_step_timer = 0.065
	_disparar_tiro_reto()

func _disparar_tiro_reto() -> void:
	if get_tree().current_scene == null:
		return
	var muzzle_pos: Vector2 = weapon_sprite.global_position + aim_direction * 12.0
	var tint := Color(0.45, 1.0, 0.55, 1.0) if projectile_damage > 1 else Color.WHITE

	var proj := Area2D.new()
	proj.set_script(ProjectileScript)

	var spr := Sprite2D.new()
	spr.texture = TEX_SHOT
	spr.scale = Vector2(0.95, 1.15)
	proj.add_child(spr)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 6.0
	col.shape = shape
	proj.add_child(col)

	get_tree().current_scene.add_child(proj)
	proj.setup(muzzle_pos, aim_direction, tint, projectile_damage)

func _tentar_dash() -> bool:
	if _is_dead or atp < 6.0 or _dash_timer > 0.0:
		return false
	var movimento_dash: Vector2 = ultima_direcao.normalized() * dash_distance
	if test_move(global_transform, movimento_dash):
		movimento_dash *= 0.5
	atp -= 6.0
	_invuln_timer = 0.25
	_dash_timer = 0.35
	move_and_collide(movimento_dash)
	_update_hud()
	return true

func take_damage(amount: int = 1, source_pos: Vector2 = Vector2.ZERO) -> void:
	if _is_dead or _invuln_timer > 0.0:
		return
	hp = maxi(0, hp - amount)
	_invuln_timer = 0.70
	if source_pos != Vector2.ZERO:
		var push_dir: Vector2 = (global_position - source_pos).normalized()
		move_and_collide(push_dir * 18.0)
	_update_hud()
	queue_redraw()
	if hp <= 0:
		_is_dead = true
		sprite.modulate = Color(0.5, 0.1, 0.1, 0.8)
		hud_status_label.text = "FALÊNCIA IMUNOLÓGICA (GAME OVER)\nPressione [R] para Reiniciar a Fase"
		hud_status_label.modulate = Color(1.0, 0.25, 0.25)
		hud_status_label.visible = true

func collect_drop(drop_type: int) -> void:
	if drop_type == DropScript.DropType.SPREAD_BUFF:
		hp = mini(max_hp, hp + 2)
		atp = max_atp
		GameState.add_score(150)
	else:
		hp = mini(max_hp, hp + 1)
		atp = minf(max_atp, atp + 8.0)
		GameState.add_score(50)
	_update_hud()
	queue_redraw()

func notify_room_cleared() -> void:
	if _is_dead or _room_cleared:
		return
	_room_cleared = true
	if GameState.current_room < GameState.max_rooms:
		if door_sprite != null:
			door_sprite.texture = TEX_DOOR_OPEN
			door_sprite.modulate = Color(0.6, 1.4, 0.7, 1.0)
		var prox_info: String = "SALA DO TESOURO" if GameState.current_room == 3 else ("SALA DO BOSS (BACTERIÓFAGO)" if GameState.current_room == 4 else ("SALA %d/5" % (GameState.current_room + 1)))
		hud_status_label.text = "SALA %d/5 CONCLUÍDA!\nPasse pela PORTA AO NORTE para ir direto à %s!" % [GameState.current_room, prox_info]
		hud_status_label.modulate = Color(0.35, 1.0, 0.45)
		hud_status_label.visible = true
	else:
		hud_status_label.text = "BACTERIÓFAGO E INFECÇÃO VIRAL EXPURGADOS!\nFASE 1 CONCLUÍDA! Pressione [R] para Jogar Novamente"
		hud_status_label.modulate = Color(0.35, 1.0, 0.35)
		hud_status_label.visible = true

func _update_hud() -> void:
	if hud_hp_bar == null:
		return
	hud_hp_bar.value = hp
	hud_hp_label.text = "%d/%d" % [hp, max_hp]
	hud_atp_bar.value = atp
	hud_atp_label.text = "%d/%d" % [int(atp), int(max_atp)]
	hud_lv_label.text = "LEVEL: %d   SALA: %d/%d" % [GameState.player_level, GameState.current_room, GameState.max_rooms]
	hud_score_label.text = "SCORE: %d" % GameState.score
	if hud_obj_label != null:
		if GameState.current_room == 4:
			hud_obj_label.text = "TESOURO: %d   (Porta Norte Abre ao Coletar)" % GameState.treasure_remaining
		else:
			hud_obj_label.text = "PORTAIS: %d   INIMIGOS: %d" % [GameState.spawners_alive, GameState.enemies_alive]

func _draw() -> void:
	var bar_w: float = 34.0
	var bar_h: float = 5.0
	var bar_pos := Vector2(-bar_w * 0.5, 20.0)
	draw_rect(Rect2(bar_pos - Vector2(1, 1), Vector2(bar_w + 2, bar_h + 2)), Color(0.08, 0.08, 0.12, 0.95))
	var ratio: float = clampf(float(hp) / float(max_hp), 0.0, 1.0)
	var fill_col := Color(0.25, 0.95, 0.35) if ratio > 0.4 else Color(0.95, 0.22, 0.22)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_col)
