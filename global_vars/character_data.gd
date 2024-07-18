extends Node

const MAX_HEALTH = 100
const MAX_AMMO = 10

var current_ammo = 10
var current_health = 100

func reset():
	current_ammo = MAX_AMMO
	current_health = MAX_HEALTH
