extends Node2D

signal teleport_to(path: String)

var paused = false
var current_weapon = null

@onready var player = $Player
@onready var ammo_label = get_node("/root/MainScene/AmmoLabel")
@onready var spawnBorders = get_node("/root/MainScene/SceneLoader/Player/Path2D/PathFollow2D")

func spawn_mob():
	var new_mob = preload("res://characters/slime/mob.tscn").instantiate()
	spawnBorders.progress_ratio = randf()
	new_mob.global_position = spawnBorders.global_position
	new_mob.slime_death.connect(play_slime_death)
	new_mob.ID = EnemyConfig.ID
	EnemyConfig.ID += 1
	add_child(new_mob)

func spawn_tree():
	var new_tree = preload("res://map_elements/tree/tree.tscn").instantiate()
	spawnBorders.progress_ratio = randf()
	new_tree.global_position = spawnBorders.global_position
	add_child(new_tree)

func spawn_rock():
	var rock = preload("res://map_elements/rock/rock.tscn").instantiate()
	spawnBorders.progress_ratio = randf()
	rock.global_position = spawnBorders.global_position
	add_child(rock)

func _on_timer_timeout():
	spawn_mob()
	spawn_tree()
	spawn_rock()

func _on_player_health_depleted():
	%GameOver.visible = true
	Engine.time_scale = 0
	
func play_slime_death(position: Vector2):
	if randi() % 100 < InterractablesConfig.HEART_UP_CHANCE:
		var heart_up = preload("res://map_elements/heart_up/heart_up.tscn").instantiate()
		heart_up.position = position
		add_child(heart_up)
	%SlimeDeath.play()

func _on_door_body_entered(body):
	teleport_to.emit("home")
