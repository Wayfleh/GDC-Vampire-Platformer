extends State

@export_range(0, 90, 0.1, "suffix: deg") var launch_angle: float
@export var launch_impulse : float = 500.0
var _dash_state: String

func enter_state():
	player.velocity = Vector2.ZERO
	_dash_state = "charge"

func update(delta : float):
	if Input.is_action_just_released("bite_dash") && _dash_state == "charge":
		player.velocity = Vector2(player.previous_direction * cos(deg_to_rad(launch_angle)) * launch_impulse, 
								-sin(deg_to_rad(launch_angle)) * launch_impulse)
		_dash_state = "dashing"
	else:
		player.apply_gravity(delta, 1)
		if player.velocity.y > 0:
			_dash_state = "falling"
	
	if player.is_on_floor() && _dash_state == "falling":
		player.velocity.x = player.speed * player.previous_direction
		player.TransformToVampire()
