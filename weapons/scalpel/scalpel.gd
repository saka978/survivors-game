extends Area2D

var enemy = null
var enemy_detected = false

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func _on_stab_frequency_timeout():
	
	if enemy_detected == true && enemy != null:
		%AnimationPlayer.play("stab")
		%StabSound.play()
		enemy.take_damage()
	
func _on_stab_area_body_entered(body):
	print(body.name)
	if body.has_method("take_damage"):
		enemy_detected = true
		enemy = body
	else:
		enemy_detected = false
