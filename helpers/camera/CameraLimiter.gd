extends Area2D

class_name CameraLimiter

enum LimitX {NONE, LEFT, RIGHT}
enum LimitY {NONE, TOP, BOTTOM}

const MAX_VAL = 100000

@export var limit_x: LimitX = LimitX.NONE
@export var limit_y: LimitY = LimitY.NONE

@onready var area = %CameraArea
@onready var camera = get_node("/root/MainScene/SceneLoader/Camera2D")

func setCameraLimits():
	print("Left: " + str(get_limit_left()))
	print("Right: " + str(get_limit_right()))
	print("Top: " + str(get_limit_top()))
	print("Bottom: " + str(get_limit_bottom()))
	
	camera.limit_left = 0
	camera.limit_right = get_limit_right()
	camera.limit_top = 0
	camera.limit_bottom = get_limit_bottom()

func get_limit_top() -> int:
	#if limit_y != LimitY.TOP:
	#	return -MAX_VAL
	return 0
	
func get_limit_bottom() -> int:
	#if limit_y != LimitY.BOTTOM:
	#	return MAX_VAL
	return %CameraArea.shape.height

func get_limit_left() -> int:
	#if limit_x != LimitX.LEFT:
	#	return -MAX_VAL
	return %CameraArea.shape.width
	
func get_limit_right() -> int:
	#if limit_x != LimitX.RIGHT:
	#	return MAX_VAL
	return 0
