## FROG
extends State

@export var _max_jump_mult : float = 1.5 #max height of frog jump is twice that of the base frog jump height
@export var _max_charge_time : float = 2.0
@export var _default_speed : float = 50.0 #TODO change this to grab from GlobalData

@export var slow_blink_interval: float = 0.25
@export var fast_blink_interval: float = 0.05

var _curr_jump_mult : float
var _time : float
var _speed_snapshot : float
var _jump_state : String
var _jump_facing_direction : int = 1

var _blink_timer: float = 0.0
var _show_charge_frame: bool = false

@onready var sound_f_jump: AudioStreamPlayer2D = $"../../../../SoundF_Jump"
@onready var sound_f_jump_wind: AudioStreamPlayer2D = $"../../../../SoundF_Jump_Wind"
@onready var sound_f_jump_hold: AudioStreamPlayer2D = $"../../../../SoundF_Jump_Hold"
@onready var frog_sprite: AnimatedSprite2D

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
	


	_blink_timer = slow_blink_interval
	_show_charge_frame = false
	frog_sprite = player.anim_sprite
	sound_f_jump_hold.finished.connect(_loop_charge_hold)
	sound_f_jump_wind.finished.connect(_loop_charge_hold)
	sound_f_jump_wind.play()
	
	#frog_sprite.play(_get_frog_idle_animation())

func _loop_charge_hold():
	if _jump_state == "charge":
		sound_f_jump_hold.play()

func update(delta: float):
	match _jump_state:
		"charge":
			if Input.is_action_just_released("jump"):
				frog_sprite.play("frog_walk_right")
				_apply_jump_impulse()
			else:
				_time = clamp(_time + delta, 0.0, _max_charge_time)
				_update_charge_blink(delta)

		"jumping":
			player.apply_horizontal_movement(delta)
			if player.velocity.y >= 0.0:
				_jump_state = "falling"

	player.apply_gravity(delta)

	if player.is_on_floor() and _jump_state == "falling":
		transitionToState.emit("F_IDLE")


func _update_charge_blink(delta: float):
	var charge_ratio := _time / _max_charge_time

	_blink_timer -= delta

	if _blink_timer <= 0.0:
		_show_charge_frame = !_show_charge_frame

		var animation: String
		if _show_charge_frame || charge_ratio == 1: #hold charge animation at max charge
			animation = "frog_charge_right"
		else:
			animation = "frog_idle_right"

		frog_sprite.play(animation)
		var current_interval := lerpf(slow_blink_interval, fast_blink_interval, charge_ratio)
		_blink_timer = current_interval




func _apply_jump_impulse():
	_curr_jump_mult -= 1.0
	_curr_jump_mult *= _time / _max_charge_time
	player.velocity.y -= player.jump_impulse * (_curr_jump_mult + 1.0) # will always jump at least as high as the base jump
	player.speed = _speed_snapshot * 1.5
	player.velocity.x = player.previous_direction * clampf(player.speed, player.speed, ARBITRARY_MAGIC_MAX_AIR_SPEED * 2)

	sound_f_jump_wind.stop() if sound_f_jump_wind.playing else sound_f_jump_wind.stop()
	sound_f_jump.play(.04)
	_jump_state = "jumping"


func exit_state():
	player.speed = _default_speed
