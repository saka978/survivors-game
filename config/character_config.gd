extends Node

const MAX_HEALTH = 100
const SPEED = 600.0
const IS_INVINCIBLE = false

var current_health = 100

func reset():
	current_health = MAX_HEALTH
