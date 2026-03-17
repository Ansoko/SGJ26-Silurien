extends Node2D

@onready var joueur = $Player
@onready var end_pos = $EndPos
@onready var fenetre_finale = $Player/Camera/CanvaLettre
@onready var letterLabel = $Player/Camera/CanvaLettre/TextureRect/RichTextLabel

@export var musicOutro: AudioStream
@export var ambianceOutro: AudioStream
@export var SFXVictory: AudioStream
@export var SFXpaper: AudioStream

func _ready() -> void:
	fenetre_finale.hide()
	lancer_sequence_fin.call_deferred()
	var stb := func():
		AudioManager.play_music.emit(musicOutro)
		AudioManager.play_ambiance.emit(ambianceOutro)
	stb.call_deferred()

func lancer_sequence_fin():
	await _deplacer_joueur_vers_spawn()
	await _lancer_dialogue()
	await _afficher_fenetre_finale()


func _deplacer_joueur_vers_spawn():
	#joueur.set_physics_process(false)
	$Player/AnimatedSprite2D.flip_h = true
	$Player/AnimatedSprite2D.play("walk")
	
	var tween = create_tween()
	tween.tween_property(
		joueur,
		"global_position",
		end_pos.global_position,
		2  # durée
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished  # attend la fin du déplacement
	$Player/AnimatedSprite2D.play("idle")

func _lancer_dialogue():
	SignalManager.start_outro.emit()
	await SignalManager.end_outro

func _afficher_fenetre_finale():
	letterLabel.text = WordManager.letterText+"\n \n\tClaire"
	fenetre_finale.show()
	AudioManager.play_SFX.emit(SFXpaper)
	
	# Animation d'apparition
	fenetre_finale.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(fenetre_finale, "modulate:a", 1.0, 1.0)
	await tween.finished
	AudioManager.play_SFX.emit(SFXVictory)
	
func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/Levels/MainLevel.tscn")
