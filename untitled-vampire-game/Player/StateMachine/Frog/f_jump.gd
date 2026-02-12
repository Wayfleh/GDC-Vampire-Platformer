## FROG
extends State

func enter_state():
	player.velocity.y -= player.jump_impulse

func update(delta: float):
	player.apply_horizontal_movement(delta)
	if !Input.is_action_pressed("jump"):
		player.apply_gravity(delta * 4)
	else:
		player.apply_gravity(delta)
	
	if player.is_on_floor() and !Input.is_action_pressed("jump"):
		transitionToState.emit("F_IDLE")

func exit_state():
	pass
