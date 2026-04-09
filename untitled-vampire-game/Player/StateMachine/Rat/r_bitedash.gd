extends State

@export_range(0, 90, 0.1, "suffix: deg") var launch_angle: float
@export var launch_impulse : float = 500.0

func enter_state():
	player.velocity = Vector2.ZERO

func update(delta : float):
	if Input.is_action_just_released("bite_dash"):
		player.velocity = Vector2(player.previous_direction * cos(deg_to_rad(launch_angle)) * launch_impulse, 
								-sin(deg_to_rad(launch_angle)) * launch_impulse)
		transitionToState.emit("R_IDLE")
