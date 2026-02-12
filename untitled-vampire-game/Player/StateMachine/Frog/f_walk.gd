## FROG
extends State

func enter_state():
	pass

func update(delta: float):
	player.velocity.x = lerpf(player.velocity.x, 0.0, delta * 10)
	
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.velocity.x == 0:
		transitionToState.emit("F_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("F_JUMP")

func exit_state():
	pass
