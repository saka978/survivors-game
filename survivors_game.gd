extends Node2D

var current_ammo = 10

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_tree():
	var new_tree = preload("res://tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position = %PathFollow2D.global_position
	add_child(new_tree)

func spawn_rock():
	var rock = preload("res://rock.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	rock.global_position = %PathFollow2D.global_position
	add_child(rock)

func _on_timer_timeout():
	spawn_mob()
	spawn_tree()
	spawn_rock()

func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true


func _on_gun_fire():
	CharacterData.current_ammo -= 1
	%AmmoLabel.text = "Ammo: " + str(CharacterData.current_ammo)
	pass
