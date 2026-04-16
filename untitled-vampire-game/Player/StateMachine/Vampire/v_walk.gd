## VAMPIRE
extends State

func enter_state():
	if player.is_on_floor():
		player.anim_sprite.play("vampire_walk")
	else:
		player.anim_sprite.play("vampire_fall")
	#walk animation

func update(delta: float):
	
	player.apply_friction(delta, 10)
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.anim_sprite.animation == "vampire_fall" && player.is_on_floor():
		player.anim_sprite.play("vampire_walk")
	
	if player.velocity.x == 0:
		transitionToState.emit("V_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("V_JUMP")
	
	if (Input.is_action_just_pressed("bite_dash") 
	&& !player.bite_dash_used):
		transitionToState.emit("V_BITEDASH")

func exit_state():
	pass
