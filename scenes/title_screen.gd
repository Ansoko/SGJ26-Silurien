extends Node2D

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_start_pressed():
	$".".hide()
	$CanvasLayer.hide()
	SignalManager.start_game.emit()
