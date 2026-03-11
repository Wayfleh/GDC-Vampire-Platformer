# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip : Node2D = $TipPivot
@onready var tip_area : Area2D = $TipPivot/TongueTip
@onready var tip_mantle_check : RayCast2D = $TipPivot/TipMantleCheck
@onready var guide_line := $GuideLine


func move_tip(speed: float):
	tip.position.y -= speed
