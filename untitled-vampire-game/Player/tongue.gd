# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip : Node2D = $TipPivot
@onready var tip_area : Area2D = $TipPivot/TongueTip
@onready var mantle_front : RayCast2D = $TipPivot/MantleFront
@onready var mantle_back : RayCast2D = $TipPivot/MantleBack
@onready var guide_line := $GuideLine



func move_tip(speed: float):
	tip.position.y -= speed


func hide_tongue():
	hide()
	tip_area.monitoring = false

# I made this one so the hide function isn't lonely <3
func show_tongue():
	show()

func monitor_tip_area():
	tip_area.monitoring = true

func is_raycast_colliding():
	print("tongue collide is")
	print(mantle_front.is_colliding() || mantle_back.is_colliding())
	return mantle_front.is_colliding() || mantle_back.is_colliding()
