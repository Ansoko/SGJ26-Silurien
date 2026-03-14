extends AnimatedSprite2D

func _ready():
	play("animation")

func _on_animation_finished():
	if animation == "animation":
		play("static")
