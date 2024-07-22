extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		if CharacterConfig.MAX_HEALTH > CharacterConfig.current_health:
			CharacterConfig.current_health += InterractablesConfig.HEART_UP_HEALING
			queue_free()
