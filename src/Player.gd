
extends CharacterBody2D

@export var speed: float = 250.0
@export var dash_distance: float = 64.0
@export var game_size: Vector2 = Vector2(1280.0, 720.0)

@onready var sprite: Sprite2D = $Player
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Direção inicial do dash: direita.
var ultima_direcao: Vector2 = Vector2.RIGHT

# Evita executar o dash repetidamente enquanto E estiver pressionada.
var dash_pendente: bool = false


func _input(event: InputEvent) -> void:
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_E
	):
		dash_pendente = true


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	# Movimento horizontal.
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0

	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0

	# Movimento vertical.
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0

	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0

	# Normaliza a direção para evitar movimento diagonal mais rápido.
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		ultima_direcao = direction

	atualizar_visual(direction)

	# Processa o dash antes do movimento normal.
	if dash_pendente:
		dash_pendente = false

		if _tentar_dash():
			return

	# Movimento normal com colisões.
	velocity = direction * speed
	move_and_slide()


func _tentar_dash() -> bool:
	if dash_distance <= 0.0:
		return false

	if collision_shape.shape == null:
		push_warning("O jogador precisa de uma forma de colisão para usar o dash.")
		return false

	var movimento_dash: Vector2 = ultima_direcao.normalized() * dash_distance

	# Impede que o personagem saia da área visível.
	if _dash_fora_dos_limites(movimento_dash):
		return false

	# Testa o trajeto completo antes de executar o dash.
	if test_move(global_transform, movimento_dash):
		return false

	# O personagem percorre o vetor de dash instantaneamente.
	move_and_collide(movimento_dash)

	return true


func _dash_fora_dos_limites(movimento: Vector2) -> bool:
	# Obtém o retângulo da forma de colisão em coordenadas globais.
	var retangulo_local: Rect2 = collision_shape.shape.get_rect()
	var retangulo_atual: Rect2 = (
		collision_shape.global_transform * retangulo_local
	)

	var limites_tela: Rect2 = Rect2(
		Vector2.ZERO,
		game_size
	)

	# Também impede o dash se o personagem já estiver fora da tela.
	if not limites_tela.encloses(retangulo_atual):
		return true

	# Calcula a posição de destino considerando o tamanho do personagem.
	var retangulo_destino: Rect2 = Rect2(
		retangulo_atual.position + movimento,
		retangulo_atual.size
	)

	return not limites_tela.encloses(retangulo_destino)


func atualizar_visual(direction: Vector2) -> void:
	if direction.x > 0.0:
		sprite.flip_h = false
		sprite.rotation_degrees = 0.0

	elif direction.x < 0.0:
		sprite.flip_h = true
		sprite.rotation_degrees = 0.0

	elif direction.y < 0.0:
		sprite.flip_h = false
		sprite.rotation_degrees = -90.0

	elif direction.y > 0.0:
		sprite.flip_h = false
		sprite.rotation_degrees = 90.0
