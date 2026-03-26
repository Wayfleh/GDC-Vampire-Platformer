## FROG
extends State

@export var _max_jump_mult : float = 1.5 #max height of frog jump is twice that of the base frog jump height
@export var _max_charge_time : float = 2.0
@export var _air_speed : float = 50.0 #frog is faster in the air after jumping
var _curr_jump_mult : float
var _time : float
var _speed_snapshot : float

var _jump_state : String

# TODO remove this shit later,
var ARBITRARY_MAGIC_MAX_AIR_SPEED: float = 300.0


func enter_state():
	print(player.velocity.x)
	_speed_snapshot = clampf(abs(player.velocity.x), player.speed, ARBITRARY_MAGIC_MAX_AIR_SPEED)
	print(_speed_snapshot)
	player.velocity.x = 0
	_time = 0.0
	_jump_state = "charge"
	_curr_jump_mult = _max_jump_mult

func update(delta: float):
	match _jump_state:
		"charge":
			if Input.is_action_just_released("jump"):
				_apply_jump_impulse()
			else:
				_time = clamp(_time + delta, 0.0, _max_charge_time)
		"jumping":
			player.apply_horizontal_movement(delta)
			if (player.velocity.y > 0.0):
				_jump_state = "falling"
			
	player.apply_gravity(delta)
	
	if player.is_on_floor() and _jump_state == "falling":
		transitionToState.emit("F_IDLE")

func _apply_jump_impulse():
	_curr_jump_mult -= 1.0
	_curr_jump_mult *= _time/_max_charge_time
	player.velocity.y -= player.jump_impulse * (_curr_jump_mult + 1.0) # will always jump at least as high as the base jump
	player.speed = _speed_snapshot
	_jump_state = "jumping"

func exit_state():
	player.speed = _air_speed
