extends State

func enter_state():
	pass

func update(delta: float):
	gp = (gp as Player) #this is just for autocorrect lol
	gp.velocity.x = lerpf(gp.velocity.x, 0.0, delta * 10)
	
	gp.handle_movement(delta)
	gp.handle_gravity(delta)
	
	if gp.velocity.x == 0:
		transition.emit("IDLE")
	
	if Input.is_action_just_pressed("jump") and gp.is_on_floor():
		transition.emit("JUMP")

func exit_state():
	pass
