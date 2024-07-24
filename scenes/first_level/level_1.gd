extends Node2D

signal change_scene(path: String)

var paused = false
var spawn_mobs = true
var current_weapon = null
var spawned_mobs = []

@onready var player = get_node("/root/MainScene/SceneLoader/Player")
@onready var goal_hud = get_node("/root/MainScene/GoalHud/")
@onready var goal_label = get_node("/root/MainScene/GoalHud/GoalLabel")
@onready var spawnBorders = get_node("/root/MainScene/SceneLoader/Player/Path2D/PathFollow2D")
@onready var sound_effect = get_node("/root/MainScene/SceneLoader/Player/SoundEffects")
@onready var camera = get_node("/root/MainScene/SceneLoader/Camera2D")

func _ready():
	ObjectivesConfig.resetObjectives()
	WeaponsConfig.reset()
	CharacterConfig.reset()
	player.global_position = %SpawnPoint.global_position
	goal_hud.show()
	goal_label.text = "Slimes Killed: %d / %d" % [ObjectivesConfig.LEVEL_1_SLIME_COUNTER, ObjectivesConfig.LEVEL_1_SLIMES]
	%SpawnEffect.play()
	$CameraLimiter.setCameraLimits()

func _physics_process(delta):
	goal_label.text = "Slimes Killed: %d / %d" % [ObjectivesConfig.LEVEL_1_SLIME_COUNTER, ObjectivesConfig.LEVEL_1_SLIMES]

func spawn_mob():
	if spawn_mobs == true:
		var new_mob = preload("res://characters/slime/mob.tscn").instantiate()
		spawnBorders.progress_ratio = randf()
		new_mob.global_position = spawnBorders.global_position
		new_mob.slime_death.connect(play_slime_death)
		new_mob.ID = EnemyConfig.ID
		EnemyConfig.ID += 1
		add_child(new_mob)
		spawned_mobs.push_front(new_mob)
		
func clear_mobs():
	for mob in spawned_mobs:
		if is_instance_valid(mob):
			mob.queue_free()

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

func play_slime_death(position: Vector2):
	%SlimeDeath.play()
	ObjectivesConfig.LEVEL_1_SLIME_COUNTER += 1
	if(ObjectivesConfig.LEVEL_1_SLIME_COUNTER == ObjectivesConfig.LEVEL_1_SLIMES):
		var portal_texture = preload("res://map_elements/portal/portal.png")
		var home_portal = preload("res://map_elements/portal/portal.tscn").instantiate()
		home_portal.position = position
		add_child(home_portal)
		%PortalImage.texture = portal_texture
		%PortalImage.global_position = home_portal.global_position
		home_portal.change_scene.connect(self._on_change_scene)
		spawn_mobs = false
		clear_mobs()
		WeaponsConfig.pistol_unlocked = true
		return
		
	if randi() % 100 < InterractablesConfig.HEART_UP_CHANCE:
		var heart_up = preload("res://map_elements/heart_up/heart_up.tscn").instantiate()
		heart_up.position = position
		add_child(heart_up)

func _on_change_scene():
	change_scene.emit("home")
