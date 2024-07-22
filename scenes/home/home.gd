extends Node2D

signal change_scene(path: String)

@onready var player = get_node("/root/MainScene/SceneLoader/Player")

func _ready():
	player.global_position = %SpawnPoint.global_position 

func _on_portal_body_entered(body):
	change_scene.emit("level_1")
