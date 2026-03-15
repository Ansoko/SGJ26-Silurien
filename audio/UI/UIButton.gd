extends Button

@export var son_hover: AudioStream
@export var son_click: AudioStream

func _ready():
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_click)

func _on_hover():
	AudioManager.play_SFX.emit(son_hover)

func _on_click():
	AudioManager.play_SFX.emit(son_click)
