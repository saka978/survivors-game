extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		if CharacterData.MAX_HEALTH > CharacterData.current_health:
			CharacterData.current_health += 10
			queue_free()
