class_name Hole extends Area2D
#for overlapping holes, priority is scene tree order

@export var other_hole: Hole
@onready var hole_sprite: Array[Texture2D] = [preload("res://Art/Sprites/VampRat/dirtmound2.png"),
										preload("res://Art/Sprites/VampRat/dirtmound_outline.png")]
var is_

func _ready() -> void:
	assert(other_hole != null, "Error: Hole must have a reference to another Hole")
	body_entered.connect(showOutline)
	body_exited.connect(hideOutline)

func ratTeleport() -> Vector2:
	$HoleSound.play()
	return other_hole.global_position

#func _process(delta: float) -> void:
	#if has_overlapping_bodies() && $Sprite2D.texture != hole_sprite[1]:
		#showOutline(get_overlapping_bodies()[0])

func showOutline(body: Node2D):
	if body is Player:
		if body.state_machine.current_state != body.state_machine.states["RAT"]:
			return
		$Sprite2D.texture = hole_sprite[1]
		$Sprite2D.offset.y = -.5

func hideOutline(body: Node2D):
	$Sprite2D.texture = hole_sprite[0]
	$Sprite2D.offset.y = 0
