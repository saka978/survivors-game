extends Control

@onready var sceneLoader = %SceneLoader

var pistol = preload("res://weapons/pistol/gun.tscn")
var scalpel = preload("res://weapons/scalpel/scalpel.tscn")

var paused = false
var current_weapon = null
var level_instance
var current_level_name

func _ready():
	load_level("main_menu")
	current_weapon = scalpel.instantiate()
	%Player.add_child(current_weapon)
	%AmmoLabel.hide()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("esc_menu"):
		escapeMenu()
	elif Input.is_action_just_pressed("weapon_1"):
		switch_weapon(scalpel)
		%AmmoLabel.hide()
	elif Input.is_action_just_pressed("weapon_2"):
		if WeaponsConfig.pistol_unlocked:
			switch_weapon(pistol)
			%AmmoLabel.show()
		
	%AmmoLabel.text = "Ammo: " + str(WeaponsConfig.current_ammo_pistol)

func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	
func load_level(level_name : String):
	current_level_name = level_name
	var level_path := "res://scenes/%s.tscn" % level_name
	var level_resource := load(level_path)
	if (level_resource):
		level_instance = level_resource.instantiate()
		sceneLoader.add_child(level_instance)
		if(object_has_signal(level_instance, "change_scene")):
			level_instance.change_scene.connect(self._on_change_scene)
		
func object_has_signal(object, signal_name) -> bool:
	var list = object.get_signal_list()
	for signal_entry in list:
		if signal_entry["name"] == signal_name:
			return true
	return false

func switch_weapon(new_weapon_scene):
	if current_weapon:
		%Player.remove_child(current_weapon)
		current_weapon.queue_free()
	current_weapon = new_weapon_scene.instantiate()
	%Player.add_child(current_weapon)

func escapeMenu():
	if %GameOver.visible != true:
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
	WeaponsConfig.current_ammo_pistol -= 1
	%AmmoLabel.text = "Ammo: " + str(WeaponsConfig.current_ammo_pistol)

func _on_restart_button_pressed():
	CharacterConfig.reset()
	WeaponsConfig.reset()
	unload_level()
	load_level(current_level_name)
	escapeMenu()
	Engine.time_scale = 1

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_game_over_pressed():
	CharacterConfig.reset()
	WeaponsConfig.reset()
	pauseMenu()
	unload_level()
	load_level(current_level_name)
	Engine.time_scale = 1
	
func _on_change_scene(path: String):
	unload_level()
	load_level(path)

func _on_player_health_depleted():
	%GameOver.visible = true
	Engine.time_scale = 0
