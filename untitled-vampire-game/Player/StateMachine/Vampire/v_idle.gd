## VAMPIRE
extends State



#TODO add animations for idle state
func enter_state():
	pass
#slows the player down to a halt
func update(delta: float):
	if player.velocity.x != 0:
		if (player.velocity.x <= 0.005): #Clamping velocity as it approaches 0 to prevent too many lerpf calls.
			player.velocity.x = 0
		else:
			player.velocity.x = lerpf(player.velocity.x, 0.0, delta * 10)
	player.apply_gravity(delta)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("V_WALK")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("V_JUMP")
		
	if Input.is_action_just_pressed("bite_dash"):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
