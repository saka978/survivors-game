extends Control

@onready var sceneLoader = %SceneLoader

var pistol = preload("res://weapons/pistol/gun.tscn")
var scalpel = preload("res://weapons/scalpel/scalpel.tscn")

var paused = false
var current_weapon = null
var level_instance

func _ready():
	load_level("level_1")
	current_weapon = pistol.instantiate()
	%Player.add_child(current_weapon)
	%AmmoLabel.show()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("esc_menu"):
		escapeMenu()
	elif Input.is_action_just_pressed("weapon_1"):
		switch_weapon(pistol)
		%AmmoLabel.show()
	elif Input.is_action_just_pressed("weapon_2"):
		switch_weapon(scalpel)
		%AmmoLabel.hide()
		
	%AmmoLabel.text = "Ammo: " + str(CharacterData.current_ammo)

func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func load_level(level_name : String):
	var level_path := "res://areas/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instantiate()
		sceneLoader.add_child(level_instance)
		level_instance.teleport_to.connect(self._on_teleport_to)

func switch_weapon(new_weapon_scene):
	if current_weapon:
		%Player.remove_child(current_weapon)
		current_weapon.queue_free()
	current_weapon = new_weapon_scene.instantiate()
	%Player.add_child(current_weapon)

func escapeMenu():
	if paused:
		%EscapeMenu.hide()
		Engine.time_scale = 1
	else:
		%EscapeMenu.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func pauseMenu():
	if paused:
		%GameOver.hide()
		Engine.time_scale = 1
	else:
		%GameOver.show()
		Engine.time_scale = 0
		
	paused = !paused
	
func _on_gun_fire():
	CharacterData.current_ammo -= 1
	%AmmoLabel.text = "Ammo: " + str(CharacterData.current_ammo)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	escapeMenu()
	Engine.time_scale = 1
	CharacterData.reset()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_game_over_pressed():
	get_tree().reload_current_scene()
	pauseMenu()
	Engine.time_scale = 1
	CharacterData.reset()
	
func _on_teleport_to(path: String):
	unload_level()
	load_level(path)
