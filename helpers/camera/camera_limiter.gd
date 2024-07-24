extends Control

@onready var camera = get_node("/root/MainScene/SceneLoader/Camera2D")

func setCameraLimits():
	camera.limit_left = 0
	camera.limit_right = get_node(".").size[0] * get_node(".").scale[0]
	camera.limit_top = 0
	camera.limit_bottom = get_node(".").size[1] * get_node(".").scale[1]
