extends CharacterBody2D

signal health_depleted

func _physics_process(delta):
	%ProgressBar.value = CharacterData.current_health
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	const DAMAGE_RATE = 50
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		if CharacterData.current_health <= 0.0:
			health_depleted.emit()
		else:
			CharacterData.current_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
			%ProgressBar.value = CharacterData.current_health
