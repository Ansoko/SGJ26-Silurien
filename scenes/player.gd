extends CharacterBody2D

@export var speed = 600
@export var GRAVITY = 1000
@export var JUMP_POWER = -500
@export var NB_JUMPS = 2
@export var ACCELERATION_SOL = 100
@export var AIR_CONTROL = 20

var screen_size
var echelle_active = false
var currentNbJumps = 2
var canMove = false

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("player")
	SignalManager.end_intro.connect(unlockMovement)

func unlockMovement():
	canMove = true

func _physics_process(delta):
	if not canMove:
		return
		
	var direction = 0
	
	if is_on_floor():
		currentNbJumps = NB_JUMPS
		
	if Input.is_action_just_pressed("jump") and currentNbJumps>0:
		currentNbJumps -= 1
		velocity.y = JUMP_POWER
	
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	
	if echelle_active == true:
		GRAVITY = 0
		if Input.is_action_pressed("climb_up"):
			velocity.y = -speed
		elif Input.is_action_pressed("climb_down"):
			velocity.y = speed
		else:
			velocity.y = 0
	else: GRAVITY = 1000
	
	var acceleration = ACCELERATION_SOL if is_on_floor() else AIR_CONTROL
	velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	#velocity.x = direction * speed
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
		
		
