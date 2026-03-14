extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		get_node("../Player").echelle_active = true


func _on_body_exited(body):
	if body.name == "Player":
		get_node("../Player").echelle_active = false
