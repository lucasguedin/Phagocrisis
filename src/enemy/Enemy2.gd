extends "res://src/enemy/Enemy1.gd"

func _ready() -> void:
	patrol_speed = 90.0
	chase_speed = 140.0
	max_health = 2
	score_value = 200
	super._ready()
