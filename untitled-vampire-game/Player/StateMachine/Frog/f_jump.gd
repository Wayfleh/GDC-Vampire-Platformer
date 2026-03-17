## FROG
extends State

@export var _max_jump_mult : float = 2.0 #max height of frog jump is twice that of the base frog jump height
@export var _max_charge_time : float = 2.0
@export var _air_speed : float = 100.0 #frog is faster in the air after jumping
var _curr_jump_mult : float
var _time : float
var _speed_snapshot : float

var _jump_state : String


func enter_state():
	player.velocity.x = 0
	_time = 0.0
	_jump_state = "charge"
	_curr_jump_mult = _max_jump_mult
	_speed_snapshot = player.speed

func update(delta: float):
	match _jump_state:
		"charge":
			if Input.is_action_just_released("jump"):
				_apply_jump_impulse()
			else:
				_time = clamp(_time + delta, 0.0, _max_charge_time)
				print(_time)
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
	player.speed = _air_speed
	_jump_state = "jumping"

func exit_state():
	player.speed = _speed_snapshot
