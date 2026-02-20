# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip = $TongueTip
@onready var guide_line := $GuideLine

func move_tip(speed: float):
	tip.position.y -= speed
