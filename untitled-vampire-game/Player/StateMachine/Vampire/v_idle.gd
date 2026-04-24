## VAMPIRE
extends State


var idle_friction_multiplier := 5.0

#TODO add animations for idle state
func enter_state():
	if !player.is_on_floor():
		player.anim_sprite.play("vampire_fall")
	else:
		player.anim_sprite.play("vampire_idle")
	#idle animation
	#player.isTransformed = false
#slows the player down to a halt
func update(delta: float):
	idle_friction_multiplier = 5.0 if player.is_on_floor() else 1.0
	player.apply_friction(delta, idle_friction_multiplier)
	player.apply_gravity(delta)
	
	if player.is_on_floor():
		player.anim_sprite.play("vampire_idle")
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
