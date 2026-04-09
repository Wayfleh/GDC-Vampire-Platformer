extends State


func update(delta: float):
	
	player.apply_friction(delta, 2)
	player.apply_gravity(delta)
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("R_WALK")
