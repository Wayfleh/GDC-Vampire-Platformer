## FROG
extends State

#TODO add animations for idle state
func enter_state():
	pass
#slows the player down to a halt
func update(delta: float):
	if player.velocity.x != 0:
		player.velocity.x = lerpf(player.velocity.x, 0.0, delta * 10)
	player.apply_gravity(delta)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("F_WALK")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("F_JUMP")

func exit_state():
	pass
