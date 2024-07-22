extends Node2D

signal change_scene(path: String)

@onready var sound_effect = get_node("/root/MainScene/SceneLoader/Player/SoundEffects")

func _ready():
	sound_effect.stream = load("res://scenes/main_menu/menu_sound.mp3")

func _on_new_game_button_pressed():
	change_scene.emit("home")
	sound_effect.play()


func _on_settings_button_pressed():
	sound_effect.play()


func _on_stats_button_pressed():
	sound_effect.play()


func _on_quit_button_pressed():
	get_tree().quit()
