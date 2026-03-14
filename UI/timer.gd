extends Control

@export var TIME = 120 

@onready var timer: Timer = $Timer
@onready var timerCanva: Control = $Texts

func _ready():
	SignalManager.end_intro.connect(start_timer)
	timerCanva.hide()

func start_timer():
	$Texts.show()
	timer.wait_time = TIME
	timer.start()
	print("Timer démarré")
	
func _on_timer_timeout() -> void:
	WordManager.saveText.emit()
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _process(delta):
	if !timer.is_stopped():
		$Texts/Timer_label.text = "encore "+str(int(timer.get_time_left())) + "s"
	
