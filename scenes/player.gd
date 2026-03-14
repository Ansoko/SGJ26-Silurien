extends CharacterBody2D

@export var speed = 400
@export var GRAVITY = 1000
@export var JUMP_POWER = -400

var screen_size

func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(delta):

	# Mouvement horizontal
	var direction = 0
	
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1

	velocity.x = direction * speed

	# Gravité
	velocity.y += GRAVITY * delta

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_POWER

	# Applique le mouvement
	move_and_slide()

	update_animation()


func update_animation():

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0

	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"

	else:
		$AnimatedSprite2D.animation = "idle"
