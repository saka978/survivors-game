extends Area2D

signal _teleport_to()

func _on_body_entered(body):
	_teleport_to.emit()
