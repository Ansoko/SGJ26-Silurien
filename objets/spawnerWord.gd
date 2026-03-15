extends Node2D

@onready var label = $Area2D/CollisionShape2D/TextureRect/Label

@export_group("Type (0=random, 1=noun, 2=verb, 3=liaison, 4=adjectif, 5=ponctuation)")
@export var wordType = 0
@export_group("Audio")
@export var SFXcollect: Array[AudioStream] = []
var joueur_present: bool = false

func _ready() -> void:
	label.add_theme_constant_override("line_spacing", -5)
	label.add_theme_color_override("font_outline_color", Color("ffffffff"))
	label.add_theme_constant_override("outline_size", 1)
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
		4: 
			label.text = WordManager.get_random_adjective()
		5: 
			label.text = WordManager.get_random_punctuation()
		_: 
			label.text = WordManager.get_random_noun()
			var roll = randf() * 100  # nombre entre 0.0 et 100.0
			if roll < 30:
				label.text = WordManager.get_random_noun()
			elif roll < 55:    # 30 + 25
				label.text = WordManager.get_random_verb()
			elif roll < 73:    # 55 + 18
				label.text = WordManager.get_random_conjunction()
			elif roll < 85:    # 73 + 12
				label.text = WordManager.get_random_adjective()
			else:              # 85 + 15
				label.text = WordManager.get_random_punctuation()
			

func _on_body_entered(player):
	if player.is_in_group("player"):
		joueur_present = true

func _on_body_exited(player):
	if player.is_in_group("player"):
		joueur_present = false
		
func _input(event):
	if joueur_present and event.is_action_pressed("grab_word"):
		AudioManager.emit_signal("play_SFX", SFXcollect.pick_random())
		WordManager.emit_signal("add_word", label.text)
		queue_free()
