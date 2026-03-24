## VAMPIRE
extends State


var idle_friction_multiplier := 2.0

#TODO add animations for idle state
func enter_state():
	player.anim_sprite.play("idle")
	#idle animation
#slows the player down to a halt
func update(delta: float):
	player.apply_friction(delta, idle_friction_multiplier)
	player.apply_gravity(delta)
	
	if player.afterimage_particles.emitting:
		player.afterimage_particles.emitting = false
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("V_WALK")
	
	if Input.is_action_just_pressed("jump"):
		transitionToState.emit("V_JUMP")
		
	if (Input.is_action_just_pressed("bite_dash") 
	&& !player.bite_dash_used):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
