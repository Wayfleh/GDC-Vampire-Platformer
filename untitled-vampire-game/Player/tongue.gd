# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip : Node2D = $TipPivot
@onready var tip_sprite : Sprite2D = $TipPivot/TipSprite
@onready var mantle_front : RayCast2D = $TipCircle/MantleFront
@onready var mantle_back : RayCast2D = $TipCircle/MantleBack

# The front and back check can only collide with bodies, not areas, 
#so they don't hit the player
@onready var front_check : RayCast2D = $TipPivot/FrontCheck
@onready var back_check : RayCast2D = $TipPivot/BackCheck
@onready var guide_line : Line2D = $GuideLine
@onready var surface_check1 := $SurfaceCheck1
@onready var mid_check := $MidSC
@onready var surface_check2 := $SurfaceCheck2
@onready var tip_circle: Sprite2D = $TipCircle
var indicator_on_previously: bool = false

func move_tip(speed: float):
	tip.position.y -= speed
	guide_line.set_point_position(1, Vector2(0, tip.position.y))


func hide_tongue():
	hide()
	tip_sprite.hide()

# I made this one so the hide function isn't lonely <3
func show_tongue():
	show()
	tip_circle.hide()
	tip_sprite.hide()

func show_tip():
	tip_sprite.show()

#returns the direction of the thing that enters the tip area
func latch_direction() -> int:
	return 1 if front_check.is_colliding() else -1 if back_check.is_colliding() else 0

func rotate_tongue(angle: float):
	rotation = angle
	tip.rotation = -angle #tip faces straight up
	tip_circle.rotation = -angle
	

#I HATE YOUUUUU I HATE YOU SO MUCH DIE DIE DIE DIE DIE DIE DIE DIE DIE
#There's probably a better way to do all of these calculations, but I'm not that smart yet
func check_surface() -> void:
	var collision_distance: float
	var collision_normal: Vector2
	var s1_cv: Vector2 = Vector2(INF, -INF)
	var s1_norm: Vector2 = Vector2.ZERO
	var s2_cv: Vector2 = Vector2(INF, -INF)
	var s2_norm: Vector2 = Vector2.ZERO
	var collision_vector: Vector2 
	if surface_check1.is_colliding():
		s1_cv = (surface_check1.get_collision_point() - global_position)
		s1_norm = surface_check1.get_collision_normal()
		if !surface_check2.is_colliding():
			collision_vector = s1_cv
			collision_normal = s1_norm
	if surface_check2.is_colliding():
		s2_cv = (surface_check2.get_collision_point() - global_position)
		s2_norm = surface_check2.get_collision_normal()
		if !surface_check1.is_colliding():
			collision_vector = s2_cv
			collision_normal = s2_norm
	if surface_check1.is_colliding() && surface_check2.is_colliding():
		var mid_cv = mid_check.get_collision_point() - global_position
		if mid_cv.length() < s1_cv.length() && mid_cv.length() < s2_cv.length():
			collision_vector = mid_cv
			collision_normal = mid_check.get_collision_normal()
		else:
			collision_vector = s1_cv if s1_cv.length() < s2_cv.length() else s2_cv
			collision_normal = s1_norm if collision_vector == s1_cv else s2_norm
	if s1_cv == Vector2(INF, -INF) && s2_cv == Vector2(INF, -INF):
		tip_circle.hide()
		guide_line.set_point_position(1, surface_check1.get_target_position())
		indicator_on_previously = false
		return
		
	var offset_angle: float
	if rotation >= 0:
		offset_angle = PI/2 - rotation if (Vector2.DOWN == collision_normal) else  rotation
	else:
		offset_angle = PI/2 + rotation if (Vector2.DOWN == collision_normal) else -rotation
	
	$TipCircle/RayCast2D.rotation = offset_angle #This is just to visualize the angle
	collision_distance = clampf(collision_vector.length() + (15/tan(offset_angle)), 30, -surface_check1.get_target_position().y)
	
	guide_line.set_point_position(1, Vector2(0, -collision_distance + 30))
	tip_circle.show()
	tip_circle.position = Vector2(0, -collision_distance + 15)
	
	

func is_mantle_check_colliding() -> bool:
	#print("tongue collide is")
	#print(mantle_front.is_colliding() || mantle_back.is_colliding())
	
	return mantle_front.is_colliding() || mantle_back.is_colliding()
