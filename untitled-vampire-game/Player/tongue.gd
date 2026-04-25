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
	guide_line.set_point_position(1, Vector2(0, tip.position.y))


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
	var collision_normal: Vector2
	var s1_cv: Vector2 = Vector2(INF, -INF)
	var s2_cv: Vector2 = Vector2(INF, -INF)
	if surface_check1.is_colliding():
		s1_cv = (surface_check1.get_collision_point() - global_position)
		collision_normal = surface_check1.get_collision_normal()
	if surface_check2.is_colliding():
		s2_cv = (surface_check2.get_collision_point() - global_position)
		collision_normal = surface_check2.get_collision_normal()
	if s1_cv == Vector2(INF, -INF) && s2_cv == Vector2(INF, -INF):
		tip_circle.hide()
		guide_line.set_point_position(1, surface_check1.get_target_position())
		return
	var collision_vector: Vector2 = s1_cv if s1_cv.x < s2_cv.x && s1_cv.y > s2_cv.y else s2_cv
	var offset_angle: float = PI/2 + abs(rotation) if (Vector2.DOWN == collision_normal) else -abs(rotation)
	collision_distance = collision_vector.length() + (15/tan(offset_angle))
	
	guide_line.set_point_position(1, Vector2(0, -collision_distance + 30))
	tip_circle.show()
	tip_circle.position = Vector2(0, -collision_distance + 15)
	
	

func is_mantle_check_colliding() -> bool:
	print("tongue collide is")
	print(mantle_front.is_colliding() || mantle_back.is_colliding())
	return mantle_front.is_colliding() || mantle_back.is_colliding()
