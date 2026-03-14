extends Node2D

@onready var label = $Label

@export_group("Type (1=noun, 2=verb, 3=conjunction)")
@export var wordType = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createWord()

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
