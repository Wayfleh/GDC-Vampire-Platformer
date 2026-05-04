## FROG
extends State

@export var tongue_length: float = 280.0
@export var rotation_speed: float = 3.5
@export var tip_speed: float = 900.0
@export_range(0, 90, 0.1, "suffix: deg") var max_angle: float
@export var pull_speed: float = 2000.0
@export var mantle_impulse: float = 2000.0
@export_range(5, 60, 0.1, "suffix: deg") var mantle_angle: float

var _dash_state : String # aim, shoot, pull
var _time : float
var _pull_direction : Vector2 
var _pull_distance : float
var _curr_angle : float
var _starting_position : Vector2
var _mantle_scalar : float
var _is_mantling : bool
var _tongue: Tongue
var _fire_distance: float

#Sounds
@onready var sound_tongue_fire : AudioStreamPlayer2D = owner.get_node("SoundF_Tongue_Fire")
@onready var sound_tongue_latch : AudioStreamPlayer2D = owner.get_node("SoundF_Tongue_Latch")
@onready var sound_tongue_retract : AudioStreamPlayer2D = owner.get_node("SoundF_Tongue_Retract")
@onready var sound_tongue_whiff : AudioStreamPlayer2D = owner.get_node("SoundF_Tongue_Whiff")


func enter_state():
	#initialize tongue stuff
	if _tongue == null:
		_tongue = player.tongue
	_tongue.rotation = max_angle
	_tongue.show_tongue()
	_tongue.tip.position.y = -10
	_tongue.surface_check1.set_target_position(Vector2(0, -tongue_length + 15))
	_tongue.surface_check2.set_target_position(Vector2(0, -tongue_length + 15))
	_time = 0.0
	
	_starting_position = player.global_position
	
	_is_mantling = false
	_dash_state = "aim"
	player.velocity = Vector2.ZERO #stop player movement while aiming
	
	player.anim_sprite.play("frog_idle_right" if player.is_on_floor() else "frog_idle_air")


func update(delta: float):
	match _dash_state:
		"aim":
			_aim_tongue(delta)
		"shoot":
			_shoot_tongue(delta)
		"pull":
			_pull_frog(delta)
			if player.is_on_ceiling() || player.is_on_wall():
				_detransform()
			if Input.is_action_just_pressed("transform"):
				_detransform()
		"mantle":
			player.velocity.x = lerpf(player.velocity.x, _mantle_scalar, delta * 100)
			if abs(player.velocity.x) >= mantle_impulse - 5:
				_time = clampf(_time + delta, 1.0, 2.0)
				player.apply_friction(delta, _time)
				player.apply_gravity(delta * 2)
			if player.is_on_floor() || player.is_on_ceiling() || player.is_on_wall():
				_detransform()
			if Input.is_action_just_pressed("transform"):
				player.velocity.x = _mantle_scalar * 2.33
				_detransform()

func _aim_tongue(delta: float):
	#awesome cosine function for moving the tongue back and forth
	_time += delta
	_curr_angle = cos(_time * rotation_speed) * deg_to_rad(max_angle)
	_tongue.rotate_tongue(_curr_angle)
	_tongue.check_surface()
	
	if Input.is_action_just_released("bite_dash"): #release button to fire tongue
		player.anim_sprite.play("frog_mouth_open_ground" if player.is_on_floor() else "frog_mouth_open_air")
		_tongue.z_index = 1
		_dash_state = "shoot"
		_time = 1.0
		sound_tongue_fire.play()
		_fire_distance = _tongue.tip_circle.position.y
		_tongue.show_tip()

# Moves tongue tip at tongue angle
# (the whole tongue node is rotated, so the tip's relative y position is moved)
func _shoot_tongue(delta: float):
	_tongue.move_tip(tip_speed * delta)
	if _tongue.tip.position.y <= -tongue_length: #switch to idle if tip hits nothing
		sound_tongue_whiff.play()
		transitionToState.emit("F_IDLE")
	elif _tongue.tip_circle.visible && _tongue.tip.position.y <= _fire_distance:
		_tip_touch_surface()
	

# connected to the tongue tip's area
# called when the tongue touches a surface
# initiates pull substate; angles the player higher if tip hits a corner
func _tip_touch_surface():
	_pull_direction = Vector2(sin(_curr_angle) * player.previous_direction, -cos(_curr_angle)) 
	#break if already getting pulled or if wall is behind tongue area
	if _dash_state == "pull" || _tongue.latch_direction() == -player.previous_direction * sign(_pull_direction.x):
		return
	_dash_state = "pull"
	if !_tongue.is_mantle_check_colliding() && !_is_mantling: #angle the velocity higher if grabbing onto a ledge
		_pull_direction.y -= sign(_pull_direction.x) * player.previous_direction * _curr_angle/2
		_is_mantling = true
	_pull_distance = (-_tongue.tip.position.y + 32 if _is_mantling 
						else -_tongue.tip.position.y - 32)
	sound_tongue_latch.play()

# Moves player in the direction of the tongue
func _pull_frog(delta: float):
	if _tongue.visible:
		_tongue.hide_tongue()
	var _current_distance = _starting_position - player.global_position
	if _current_distance.length() <= _pull_distance:
		player.velocity = player.velocity.move_toward(_pull_direction.normalized() * pull_speed, delta * pull_speed)
	elif (_current_distance.length() >= _pull_distance && !_is_mantling):
		_detransform();
	else: #mantle when distance moved is equal to tongue length and you're mantling
		#.length() is magnitude of a Vector2 btw
		sound_tongue_retract.play()
		_dash_state = "mantle"
		_mantle_scalar = mantle_impulse if _pull_direction.x > 0 else -mantle_impulse #impulse direction
		var _mar = deg_to_rad(mantle_angle) #mantle angle (in) radians
		player.velocity = player.velocity.length() * ( Vector2(cos(_mar), -sin(_mar)) if _pull_direction.x > 0
					else Vector2(-cos(_mar), -sin(_mar) ) )

func _detransform():
		exit_state()
		player.TransformToVampire()

func exit_state():
	_tongue.z_index = 0
	_tongue.hide_tongue()
