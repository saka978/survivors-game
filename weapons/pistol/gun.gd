extends Area2D

signal fire

var enemy_detected = false

func _physics_process(delta):
	if Input.is_action_just_pressed("reload"):
		reload()
		return
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
		if WeaponsConfig.current_ammo_pistol == 0:
			reload()
			return
		%gunshot.play()
		WeaponsConfig.current_ammo_pistol -= 1
		shoot()
		fire.emit()
	
	enemy_detected = false;
	
func reload():
	if WeaponsConfig.current_ammo_pistol != WeaponsConfig.MAX_AMMO_PISTOL && %ReloadTimeout.time_left == 0.0:
		%ReloadTimeout.start()
		%reload.play()

func _on_reload_timeout_timeout():
	WeaponsConfig.current_ammo_pistol = 10
	%ReloadTimeout.stop()
