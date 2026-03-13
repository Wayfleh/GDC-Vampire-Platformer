## FROG
extends State


#TODO add animations for idle state
func enter_state():
	pass

#slows the player down to a halt
func update(delta: float):
	var friction_mult = 10 if player.is_on_floor() else 5
	player.apply_friction(delta, friction_mult)
	player.apply_gravity(delta)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("F_WALK")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("F_JUMP")

func exit_state():
	pass
