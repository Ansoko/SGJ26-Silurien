extends CharacterBody2D

var speed = 400
var GRAVITY = 1000
var JUMP_POWER = -500

var screen_size

func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(delta):

	var direction = 0
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_POWER
		
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1

	velocity.x = direction * speed
	velocity.y += GRAVITY * delta

	move_and_slide()
	update_animation()


func update_animation():

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0 and velocity.y == 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0

	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"

	else:
		$AnimatedSprite2D.animation = "idle"
