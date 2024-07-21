extends Area2D

var enemy = null
var enemy_detected_array = []
var enemy_attack_array = []

func _physics_process(delta):
	if enemy_detected_array.size() > 0:
		var closest_enemy = null
		var closest_distance = INF

		for enemy in enemy_detected_array:
			if is_instance_valid(enemy):
				var distance = global_position.distance_to(enemy.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_enemy = enemy
		
		if closest_enemy != null:
			look_at(closest_enemy.global_position)

func _on_stab_frequency_timeout():
	if enemy_attack_array.front() != null:
		%AnimationPlayer.play("stab")
		%StabSound.play()
		for enemy in enemy_attack_array:
			if is_instance_valid(enemy):
				enemy.take_damage()
	
func _on_stab_area_body_entered(body):
	if body.has_method("take_damage"):
		enemy_attack_array.push_front(body)

func _on_stab_area_body_exited(body):
	if body.has_method("take_damage"):
		for i in len(enemy_attack_array):
			if is_instance_valid(enemy_attack_array[i]):
				if body.ID == enemy_attack_array[i].ID:
					enemy_attack_array.remove_at(i)
					return

func _on_body_entered(body):
	enemy_detected_array.push_front(body)

func _on_body_exited(body):
	for i in len(enemy_detected_array):
		if is_instance_valid(enemy_detected_array[i]):
			if body.ID == enemy_detected_array[i].ID:
				enemy_detected_array.remove_at(i)
				return
