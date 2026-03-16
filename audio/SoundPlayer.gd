extends AudioStreamPlayer

@export_enum("Music", "Ambiance", "SFX", "Footsteps") var typeSound

func _ready() -> void:
	match typeSound:
		0:
			AudioManager.play_music.connect(playPlayer)
		1:
			AudioManager.play_ambiance.connect(playPlayer)
		2:
			AudioManager.play_SFX.connect(playPlayer)
		_:
			AudioManager.play_footstep.connect(playPlayer)

func playPlayer(newStream: AudioStream):
	stream = newStream
	play()

func stopPlayer():
	stop()
