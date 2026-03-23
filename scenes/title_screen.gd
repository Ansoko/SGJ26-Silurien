extends Node2D

@export var music_menu : AudioStream
@export var ambiance_menu : AudioStream
@export var music_game : AudioStream
@export var ambiance_game : AudioStream

@onready var introPlayer: AudioStreamPlayer = $IntroAudioPlayer
var creditScene = load("res://scenes/credits.tscn")

func _ready() -> void:
	var stb := func():
		AudioManager.play_music.emit(music_menu)
		AudioManager.play_ambiance.emit(ambiance_menu)
	stb.call_deferred()

func _on_credits_pressed():
	var instance = creditScene.instantiate()
	add_child(instance)

func _on_start_pressed():
	$".".hide()
	introPlayer.stop()
	AudioManager.play_music.emit(music_game)
	AudioManager.play_ambiance.emit(ambiance_game)
	SignalManager.start_game.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
