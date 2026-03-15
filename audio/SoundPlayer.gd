extends AudioStreamPlayer

@export_enum("Music", "SFX") var typeSound

func _ready() -> void:
	match typeSound:
		0:
			AudioManager.play_music.connect(playPlayer)
		_:
			AudioManager.play_SFX.connect(playPlayer)

func playPlayer(newStream: AudioStream):
	stream = newStream
	play()

func stopPlayer():
	stop()
