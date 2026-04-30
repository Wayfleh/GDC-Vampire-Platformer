extends State

func enter_state():
	player.anim_sprite.play("rat_walk")

func update(delta: float):
	
	player.apply_friction(delta, 10)
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.velocity.x == 0:
		transitionToState.emit("R_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transitionToState.emit("R_JUMP")
	

func exit_state():
	player.anim_sprite.stop()
