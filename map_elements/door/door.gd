extends Area2D

signal change_scene()

func _on_body_entered(body):
	change_scene.emit()
