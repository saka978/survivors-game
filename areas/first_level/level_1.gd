extends Node2D

var paused = false
var pistol = preload("res://weapons/pistol/gun.tscn")
var scalpel = preload("res://weapons/scalpel/scalpel.tscn")
var current_weapon = null

@onready var player = $Player

func _ready():
	current_weapon = pistol.instantiate()
	player.add_child(current_weapon)

func _physics_process(delta):
	if Input.is_action_just_pressed("esc_menu"):
		escapeMenu()
	elif Input.is_action_just_pressed("weapon_1"):
		switch_weapon(pistol)
	elif Input.is_action_just_pressed("weapon_2"):
		switch_weapon(scalpel)

func switch_weapon(new_weapon_scene):
	if current_weapon:
		player.remove_child(current_weapon)
		current_weapon.queue_free()
	current_weapon = new_weapon_scene.instantiate()
	player.add_child(current_weapon)

func spawn_mob():
	var new_mob = preload("res://characters/slime/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.slime_death.connect(play_slime_death)
	new_mob.ID = EnemyConfig.ID
	EnemyConfig.ID += 1
	add_child(new_mob)

func spawn_tree():
	var new_tree = preload("res://map_elements/tree/tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position = %PathFollow2D.global_position
	add_child(new_tree)

func spawn_rock():
	var rock = preload("res://map_elements/rock/rock.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	rock.global_position = %PathFollow2D.global_position
	add_child(rock)
	
func pauseMenu():
	if paused:
		%GameOver.hide()
		Engine.time_scale = 1
	else:
		%GameOver.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func escapeMenu():
	if paused:
		%EscapeMenu.hide()
		Engine.time_scale = 1
	else:
		%EscapeMenu.show()
		Engine.time_scale = 0
		
	paused = !paused

func _on_timer_timeout():
	spawn_mob()
	spawn_tree()
	spawn_rock()

func _on_player_health_depleted():
	%GameOver.visible = true
	Engine.time_scale = 0

func _on_gun_fire():
	CharacterData.current_ammo -= 1
	%AmmoLabel.text = "Ammo: " + str(CharacterData.current_ammo)
	
func play_slime_death(position: Vector2):
	if randi() % 100 < InterractablesConfig.HEART_UP_CHANCE:
		var heart_up = preload("res://map_elements/heart_up/heart_up.tscn").instantiate()
		heart_up.position = position
		add_child(heart_up)
	%SlimeDeath.play()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	pauseMenu()
	Engine.time_scale = 1
	CharacterData.reset()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_door_body_entered(body):
	var current_scene_file = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://areas/home/home.tscn")
