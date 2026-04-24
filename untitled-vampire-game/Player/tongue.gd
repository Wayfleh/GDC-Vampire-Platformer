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
@onready var guide_line : Line2D = $GuideLine
@onready var surface_check1 := $SurfaceCheck1
@onready var surface_check2 := $SurfaceCheck2
@onready var tip_circle: Sprite2D = $TipCircle

func move_tip(speed: float):
	tip.position.y -= speed


func hide_tongue():
	hide()
	tip_area.monitoring = false

# I made this one so the hide function isn't lonely <3
func show_tongue():
	show()
	tip_circle.hide()

#returns the direction of the thing that enters the tip area
func latch_direction() -> int:
	return 1 if front_check.is_colliding() else -1 if back_check.is_colliding() else 0

func check_surface() -> void:
	var collision_distance: float
	var s1_cd: float = INF
	var s2_cd: float = INF
	if !surface_check1.is_colliding() && !surface_check2.is_colliding():
		tip_circle.hide()
		guide_line.set_point_position(1, surface_check1.get_target_position())
		return
	if surface_check1.is_colliding():
		s1_cd = (surface_check1.get_collision_point() - global_position).length()
	if surface_check2.is_colliding():
		s2_cd = (surface_check2.get_collision_point() - global_position).length()
	collision_distance = minf(s1_cd, s2_cd) + (15/abs(tan(rotation)))
	guide_line.set_point_position(1, Vector2(0, -collision_distance + 30))
	tip_circle.show()
	tip_circle.position = Vector2(0, -collision_distance + 15)
	print(collision_distance)
	
	

func is_mantle_check_colliding() -> bool:
	print("tongue collide is")
	print(mantle_front.is_colliding() || mantle_back.is_colliding())
	return mantle_front.is_colliding() || mantle_back.is_colliding()
