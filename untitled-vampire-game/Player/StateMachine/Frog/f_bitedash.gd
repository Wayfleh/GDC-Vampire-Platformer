## FROG
extends State

@export var tongue_length: float = 80.0
@export var rotation_speed: float
@export var tip_speed: float
@export_range(0, 90, 0.1, "suffix: deg") var max_angle: float

var dash_state : String # aim, shoot, pull
var time : float

func enter_state():
	player.tongue.rotation = max_angle
	player.velocity = Vector2.ZERO #stop player movement while aiming
	dash_state = "aim"
	player.tongue.show()
	time = 0.0

func update(delta: float):
	match dash_state:
		"aim":
			_aim_tongue(delta)
		"shoot":
			_shoot_tongue(delta)
		"pull":
			_pull_frog(delta)

func _aim_tongue(delta: float):
	time += delta
	var angle = cos(time * rotation_speed) * deg_to_rad(max_angle)
	player.tongue.rotation = angle
	if Input.is_action_just_released("bite_dash"):
		dash_state = "shoot"

func _shoot_tongue(delta: float):
	player.tongue.move_tip(tip_speed * delta)
	if player.tongue_tip.position.y <= -tongue_length:
		dash_state = "pull"

func _pull_frog(delta: float):
	#remove later
	player.apply_gravity(delta, 1)
	
	if (player.is_on_wall() || player.is_on_floor()):
		transitionToState.emit("F_IDLE")

func exit_state():
	player.tongue.hide()
