class_name Hole extends Area2D

@export var other_hole: Hole

func _ready() -> void:
	assert(other_hole != null, "Error: Hole must have a reference to another Hole")

func ratTeleport() -> Vector2:
	return other_hole.global_position
