extends AnimatedSprite2D

func _ready():
	hide()
	$"../AnimationTitreFond_2".hide()

func _on_title__animated_sprite_2d__1_animation_finished() -> void:
	show()
	var fond = $"../AnimationTitreFond_2"
	fond.show()
	fond.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(fond, "modulate:a", 1.0, 3.0)

	play("animation")


func _on_animation_finished():
	if animation == "animation":
		play("static")
		
