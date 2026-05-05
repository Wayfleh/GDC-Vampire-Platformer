extends State

@export_range(0, 90, 0.1, "suffix: deg") var launch_angle: float
@export var launch_impulse : float = 500.0
var _dash_state: String
@onready var rat_sound_fling: AudioStreamPlayer2D = $"../../../../SoundR_Fling"

func enter_state():
	player.anim_sprite.play("rat_dash")
	player.velocity = Vector2.ZERO
	player.anim_sprite.set_offset(Vector2.ZERO)
	player.velocity = Vector2(player.previous_direction * cos(deg_to_rad(launch_angle)) * launch_impulse, 
							-sin(deg_to_rad(launch_angle)) * launch_impulse)
	_dash_state = "dashing"
	rat_sound_fling.play()

func update(delta : float):
	player.apply_gravity(delta, 1)
	if player.velocity.y >= 0:
		_dash_state = "falling"
	
	if player.is_on_floor() && _dash_state == "falling":
		player.velocity.x = player.speed * player.previous_direction
		player.TransformToVampire()

func exit_state():
	player.anim_sprite.set_offset(Vector2(-5, 3))
	player.anim_sprite.stop()
