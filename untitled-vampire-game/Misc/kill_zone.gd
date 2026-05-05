class_name KillZone extends Area2D

func _ready() -> void:
	body_entered.connect(kill_al_lecarte)

func kill_al_lecarte(body: Node2D):
	if body is Player:
		body.restart()
