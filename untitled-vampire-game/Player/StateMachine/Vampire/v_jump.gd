## VAMPIRE
extends State

@export var fastFallGravityMultiplier = 4 #When the player isn't pressing the jump button, fall faster.

func enter_state():
	player.velocity.y -= player.jump_impulse

func update(delta: float):
	player.apply_horizontal_movement(delta)
	if !Input.is_action_pressed("jump"):
		player.apply_gravity(delta * fastFallGravityMultiplier)
	else:
		player.apply_gravity(delta)
	
	if player.is_on_floor() and !Input.is_action_pressed("jump"):
		transitionToState.emit("V_IDLE")
	
	if Input.is_action_just_pressed("bite_dash"):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
