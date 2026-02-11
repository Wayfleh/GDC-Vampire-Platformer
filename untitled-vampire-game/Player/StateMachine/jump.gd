extends State

func enter_state():
	gp.velocity.y -= gp.JUMP_IMPULSE

func update(delta: float):
	gp = (gp as Player) #this is just for autocorrect lol
	gp.apply_horizontal_movement(delta)
	if !Input.is_action_pressed("jump"):
		gp.apply_gravity(delta * 4)
	else:
		gp.apply_gravity(delta)
	
	if gp.is_on_floor() and !Input.is_action_pressed("jump"):
		transitionToState.emit("IDLE")

func exit_state():
	pass
