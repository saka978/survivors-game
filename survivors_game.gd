extends Node2D

func spawn_mob():
	var new_mob = preload("res://characters/slime/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	new_mob.slime_death.connect(play_slime_death)
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
	
func play_slime_death():
	%SlimeDeath.play()
