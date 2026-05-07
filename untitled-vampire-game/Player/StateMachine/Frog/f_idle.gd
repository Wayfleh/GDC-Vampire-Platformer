## FROG
extends State


#TODO add animations for idle state
func enter_state():
	
	#TODO fix the current_direction bullshit in player so it doesn't change the scale of the nodes at all, cause that's gonna mess with stuff later
	player.anim_sprite.play("frog_idle_right")

#slows the player down to a halt
func update(delta: float):
	var friction_mult = 5 if player.is_on_floor() else 2
	player.apply_friction(delta, friction_mult)
	player.apply_gravity(delta)
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		transitionToState.emit("F_WALK")
	
	if Input.is_action_just_pressed("jump") and (player.frog_floor_check.is_colliding() || player.is_on_floor()):
		transitionToState.emit("F_JUMP")

func exit_state():
	pass
