extends Node2D

@onready var timer: Timer = $Timer

func _ready():
	SignalManager.start_game.connect(start_timer)

func start_timer():
	timer.start()
	print("Timer démarré")
	
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
