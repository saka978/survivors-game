extends Node2D

signal teleport_to(path: String)

func _on_portal_body_entered(body):
	teleport_to.emit("level_1")
