# helper class for FROG
class_name Tongue
extends Node2D

@onready var tip : Area2D = $TongueTip
@onready var guide_line := $GuideLine

func move_tip(speed: float):
	tip.position.y -= speed
