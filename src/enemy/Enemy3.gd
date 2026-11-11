extends "res://src/enemy/Enemy1.gd"

func _ready() -> void:
	patrol_speed = 55.0
	chase_speed = 85.0
	max_health = 5
	score_value = 300
	super._ready()
