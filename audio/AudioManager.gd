extends Node

const BUS_MUSIQUE = "Music"
const BUS_SFX = "SFX"

@onready var musique_player = $Sound/Musique
@onready var sfx_player = $Sound/SFX

func play_music(stream: AudioStream, fade: bool = false):
	if musique_player.stream == stream:
		return
	musique_player.stream = stream
	musique_player.play()

func stop_music():
	musique_player.stop()

func set_volume_musique(volume: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_MUSIQUE),
		linear_to_db(volume)  # volume entre 0.0 et 1.0
	)

func play_sfx(stream: AudioStream):
	if sfx_player.stream == stream:
		return
	sfx_player.stream = stream
	sfx_player.play()

func set_volume_sfx(volume: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_SFX),
		linear_to_db(volume)
	)
