extends Node2D

@onready var timer: Timer = $CanvaUI/Timer_elements/Timer

func _ready():
	SignalManager.start_game.connect(start_timer)
	$CanvaUI/Timer_elements/Texts/Timer_label.hide()

func start_timer():
	$CanvaUI/Timer_elements/Texts/Timer_label.show()
	timer.start()
	print("Timer démarré")
	
	
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _process(delta):
	if !timer.is_stopped():
		$CanvaUI/Timer_elements/Texts/Timer_label.text = str(int(timer.get_time_left())) + "s left."
	
