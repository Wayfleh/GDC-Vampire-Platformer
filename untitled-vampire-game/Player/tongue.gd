# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip : Node2D = $TipPivot
@onready var tip_area : Area2D = $TipPivot/TongueTip
@onready var mantle_front : RayCast2D = $TipPivot/MantleFront
@onready var mantle_back : RayCast2D = $TipPivot/MantleBack

# The front and back check can only collide with bodies, not areas, 
#so they don't hit the player
@onready var front_check : RayCast2D = $TipPivot/FrontCheck
@onready var back_check : RayCast2D = $TipPivot/BackCheck
@onready var guide_line := $GuideLine


func move_tip(speed: float):
	tip.position.y -= speed


func hide_tongue():
	hide()
	tip_area.monitoring = false

# I made this one so the hide function isn't lonely <3
func show_tongue():
	show()

#returns the direction of the thing that enters the tip area
func latch_direction() -> int:
	return 1 if front_check.is_colliding() else -1 if back_check.is_colliding() else 0

func is_mantle_check_colliding() -> bool:
	print("tongue collide is")
	print(mantle_front.is_colliding() || mantle_back.is_colliding())
	return mantle_front.is_colliding() || mantle_back.is_colliding()
