extends Node2D

@export var music_menu : AudioStream
@export var music_game : AudioStream

func _ready() -> void:
	var stb := func():
		AudioManager.play_music.emit(music_menu)
	stb.call_deferred()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_start_pressed():
	$".".hide()
	AudioManager.play_music.emit(music_game)
	SignalManager.start_game.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
