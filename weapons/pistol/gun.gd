extends Area2D

signal fire

var enemy_detected = false

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		enemy_detected = true

func shoot():
	const BULLET = preload("res://weapons/pistol/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout():
	if enemy_detected == true && %ReloadTimeout.is_stopped():
		if CharacterData.current_ammo == 0:
			%ReloadTimeout.start()
			%reload.play()
			return
		%gunshot.play()
		shoot()
		fire.emit()
	
	enemy_detected = false;


func _on_reload_timeout_timeout():
	CharacterData.current_ammo = 10
	%ReloadTimeout.stop()
