extends Node

const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"

signal play_music(stream: AudioStream)
signal play_SFX(stream: AudioStream)

func set_volume_musique(volume: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_MUSIC),
		linear_to_db(volume)  # volume entre 0.0 et 1.0
	)

func set_volume_sfx(volume: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_SFX),
		linear_to_db(volume)
	)
