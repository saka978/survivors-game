extends CharacterBody2D

signal health_depleted

func _physics_process(delta):
	%ProgressBar.value = CharacterConfig.current_health
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * CharacterConfig.SPEED
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	const DAMAGE_RATE = EnemyConfig.SLIME_DAMAGE
	
	if !CharacterConfig.IS_INVINCIBLE:
		var overlapping_mobs = %HurtBox.get_overlapping_bodies()
		if overlapping_mobs.size() > 0:
			if CharacterConfig.current_health <= 0.0:
				health_depleted.emit()
			else:
				CharacterConfig.current_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
				%ProgressBar.value = CharacterConfig.current_health
