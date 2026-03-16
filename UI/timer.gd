extends Control

@export var TIME = 120 
@export var SFXTimer : AudioStream

@onready var timer: Timer = $Timer
@onready var timerCanva: Control = $Texts
var alarmPlayed: bool=true

func _ready():
	SignalManager.end_intro.connect(start_timer)
	timer.stop()
	timerCanva.hide()

func start_timer():
	timerCanva.show()
	timer.wait_time = TIME
	timer.start()
	alarmPlayed = false
	
func _on_timer_timeout() -> void:
	WordManager.saveText.emit()
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")

func _process(delta):
	if !timer.is_stopped():
		$Texts/Timer_label.text = formater_temps(timer.get_time_left())
	if timer.get_time_left() < 12.0:
		if not alarmPlayed and timer.get_time_left() < 11.0:
			alarmPlayed = true
			var p = AudioStreamPlayer.new()
			p.bus = "SFX"
			add_child(p)
			p.stream = SFXTimer
			p.play()
			p.finished.connect(p.queue_free)
		if fmod(timer.get_time_left(), 1.0) < delta * 2:
			var tween = create_tween()
			tween.tween_property($Texts/Timer_label, "scale", Vector2.ONE * 1.15, 0.08)
			tween.tween_property($Texts/Timer_label, "scale", Vector2.ONE, 0.08)
	
func formater_temps(secondes: float) -> String:
	var minutes = int(secondes) / 60
	var secs = int(secondes) % 60
	return "%d:%02d" % [minutes, secs]
