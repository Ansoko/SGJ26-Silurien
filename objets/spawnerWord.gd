extends Node2D

@onready var label = $Label

@export_group("Type (1=noun, 2=verb, 3=conjunction)")
@export var wordType = 1

var joueur_present: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createWord()
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func createWord():
	match wordType:
		1:
			label.text = WordManager.get_random_noun()
		2:
			label.text = WordManager.get_random_verb()
		3: 
			label.text = WordManager.get_random_conjunction()
		_: 
			label.text = WordManager.get_random_noun()

func _on_body_entered(player):
	if player.is_in_group("player"):
		joueur_present = true

func _on_body_exited(player):
	if player.is_in_group("player"):
		joueur_present = false
		
func _input(event):
	if joueur_present and event.is_action_pressed("grab_word"):
		WordManager.emit_signal("add_word", label.text)
		queue_free()
