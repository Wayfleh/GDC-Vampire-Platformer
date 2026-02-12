extends State


#TODO add animations for idle state
func enter_state():
	pass
#slows the player down to a halt
func update(delta: float):
	gp = (gp as Player) #this is just for autocorrect lol
	gp.apply_gravity(delta)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("WALK")
	
	if Input.is_action_just_pressed("jump") and gp.is_on_floor():
		transitionToState.emit("JUMP")

func exit_state():
	pass
