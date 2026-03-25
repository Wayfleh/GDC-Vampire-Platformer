## VAMPIRE
extends State

@export var fastFallGravityMultiplier: float = 1.5 #When the player isn't pressing the jump button, fall faster.

func enter_state():
	player.anim_sprite.play("vampire_jump")
	player.velocity.y -= player.jump_impulse
	player.play_jump_sound()

func update(delta: float):
	player.apply_horizontal_movement(delta)
	if !Input.is_action_pressed("jump"):
		player.apply_gravity(delta, fastFallGravityMultiplier)
	else:
		player.apply_gravity(delta, 1)
	
	if player.is_on_floor() and !Input.is_action_pressed("jump"):
		transitionToState.emit("V_IDLE")
	
	if player.velocity.y > 0 && !player.is_on_floor():
		player.anim_sprite.play("vampire_fall")
	
	# can only bite dash once in the air
	if (Input.is_action_just_pressed("bite_dash") 
	&& !player.bite_dash_used):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
