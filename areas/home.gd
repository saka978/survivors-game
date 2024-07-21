extends Node2D

signal teleport_to(path: String)

@onready var player = get_node("/root/MainScene/SceneLoader/Player")

func _ready():
	player.global_position = %SpawnPoint.global_position 

func _on_portal_body_entered(body):
	teleport_to.emit("level_1")
