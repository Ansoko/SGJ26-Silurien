extends CharacterBody2D

@export var speed = 600
@export var speedOnLadder = 400
@export var GRAVITY = 1000
@export var JUMP_POWER = -500
@export var NB_JUMPS = 2
@export var ACCELERATION_SOL = 100
@export var AIR_CONTROL = 20

@export var SFXJumps: Array[AudioStream] = []
@export var SFXFootsteps: Array[AudioStream] = []
@export var INTERVALLE_PAS = 0.3  # secondes entre chaque pas
@export var SFXLadder: Array[AudioStream] = []
@export var INTERVALLE_LADDER = 0.3  # secondes entre chaque pas

var screen_size
var currentNbJumps = 2
var canMove = false

var sur_echelle: bool = false
var can_climb: bool = false
var timer_pas: float = 0.0
var timer_ladder: float = 0.0
var currentGravity = 1200

@onready var echelle_detector = $EchelleDetector

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("player")
	SignalManager.end_intro.connect(unlockMovement)
	SignalManager.start_outro.connect(playAnimationEnd)
	
	echelle_detector.body_entered.connect(_on_echelle_entered)
	echelle_detector.body_exited.connect(_on_echelle_exited)
	echelle_detector.area_entered.connect(_on_echelle_entered)
	echelle_detector.area_exited.connect(_on_echelle_exited)
	
	$AnimatedSprite2D.animation = "idle"
	
func _on_echelle_entered(_area):
	sur_echelle = true
	
func _on_echelle_exited(_area):
	sur_echelle = false
	can_climb = false

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
		AudioManager.play_footstep.emit(SFXJumps.pick_random())
	
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	
	if sur_echelle:
		if not can_climb and (Input.is_action_pressed("climb_up") or Input.is_action_pressed("climb_down")):
			can_climb = true
			
		if can_climb:
			currentGravity = 0
			if Input.is_action_pressed("climb_up"):
				velocity.y = -speedOnLadder
			elif Input.is_action_pressed("climb_down"):
				velocity.y = speedOnLadder
			else:
				velocity.y = 0
	else: currentGravity = GRAVITY
	
	var acceleration = ACCELERATION_SOL if is_on_floor() else AIR_CONTROL
	velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	#velocity.x = direction * speed
	velocity.y += currentGravity * delta

	move_and_slide()
	update_animation(delta)

func update_animation(delta: float):

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0 and velocity.y == 0 and not sur_echelle:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
		playSFXFootprint(delta)

	elif (velocity.y!=0 or velocity.x!=0) && can_climb:
		playSFXLadder(delta)
		$AnimatedSprite2D.animation = "climb"

	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "jump"
	
	elif not sur_echelle and not can_climb:
		$AnimatedSprite2D.animation = "idle"
		
func playAnimationEnd():
	canMove=false
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("walk")
	await get_tree().create_timer(2).timeout
	$AnimatedSprite2D.play("idle")

func playSFXFootprint(delta):
	timer_ladder = 0
	timer_pas += delta
	if timer_pas >= INTERVALLE_PAS:
		timer_pas = 0.0
		AudioManager.play_footstep.emit(SFXFootsteps.pick_random())
		
func playSFXLadder(delta):
	timer_pas = 0
	timer_ladder += delta
	if timer_ladder >= INTERVALLE_LADDER:
		timer_ladder = 0.0
		AudioManager.play_footstep.emit(SFXLadder.pick_random())
