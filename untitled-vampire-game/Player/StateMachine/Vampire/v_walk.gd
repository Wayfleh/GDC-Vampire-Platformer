## VAMPIRE
extends State

func enter_state():
	pass

func update(delta: float):
	if (player.velocity.x <= 0.005): #Clamping velocity as it approaches 0 to prevent too many lerpf calls.
		player.velocity.x = 0
	else:
		player.velocity.x = lerpf(player.velocity.x, 0.0, delta * 10)
	
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.velocity.x == 0:
		transitionToState.emit("V_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("V_JUMP")
	
	if Input.is_action_just_pressed("bite_dash"):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
