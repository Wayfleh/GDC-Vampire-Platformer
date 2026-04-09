extends State


# Called when the node enters the scene tree for the first time.
func enter_state():
	player.velocity.y -= player.jump_impulse


func update(delta: float):
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta, 1.0)
	if player.is_on_floor() and !Input.is_action_pressed("jump"):
		transitionToState.emit("R_IDLE")
