extends State

func enter_state():
	pass

func update(delta: float):
	gp = (gp as Player) #this is just for autocorrect lol
	gp.velocity.x = lerpf(gp.velocity.x, 0.0, delta * 10)
	
	gp.apply_horizontal_movement(delta)
	gp.apply_gravity(delta)
	
	if gp.velocity.x == 0:
		transitionToState.emit("IDLE")
	
	if Input.is_action_just_pressed("jump") and gp.is_on_floor():
		transitionToState.emit("JUMP")

func exit_state():
	pass
