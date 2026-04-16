extends State


func update(delta: float):
	
	player.apply_friction(delta, 2)
	player.apply_gravity(delta)
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("R_WALK")
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("R_JUMP")
