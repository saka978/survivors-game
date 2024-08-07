extends CharacterBody2D

var health = EnemyConfig.SLIME_MAX_HEALTH
var ID

signal slime_death(position: Vector2)
@onready var player = get_node("/root/MainScene/SceneLoader/Player")

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * EnemyConfig.SLIME_SPEED
	move_and_slide()

func take_damage():
	health -= 1
	
	%Slime.play_hurt()
	if health <= 0:
		slime_death.emit(%Slime.global_position)
		queue_free()
		const SMOKE_SCENE = preload("res://characters/slime/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		
		smoke.global_position = global_position
