## FROG
extends State

@export var tongue_length: float = 80.0
@export var rotation_speed: float
@export var tip_speed: float
@export_range(0, 90, 0.1, "suffix: deg") var max_angle: float
@export var pull_speed: float = 2000.0
@export var mantle_impulse: float = 2000.0
@export_range(5, 60, 0.1, "suffix: deg") var mantle_angle: float

var _dash_state : String # aim, shoot, pull
var _time : float
var _pull_direction : Vector2 
var _curr_angle : float
var _starting_position : Vector2
var _mantle_scalar : float
var _mantle_vector : Vector2
var _is_mantling : bool

func enter_state():
	#initialize tongue stuff
	player.tongue.rotation = max_angle
	player.tongue.show_tongue()
	player.tongue.tip.position.y = -10
	_time = 0.0
	player.tongue.tip_area.body_entered.connect(_tip_touch_surface) #TODO find a way to put this in a _ready() function without node hierarchy shit getting in the way
	
	_starting_position = player.global_position
	
	_is_mantling = false
	_dash_state = "aim"
	player.velocity = Vector2.ZERO #stop player movement while aiming


func update(delta: float):
	match _dash_state:
		"aim":
			_aim_tongue(delta)
		"shoot":
			_shoot_tongue(delta)
		"pull":
			_pull_frog(delta)
		"mantle":
			player.velocity.x = lerpf(player.velocity.x, _mantle_scalar, delta * 100)
			if abs(player.velocity.x) >= mantle_impulse - 5:
				player.apply_friction(delta, 2)
				player.apply_gravity(delta * 2)
			if player.is_on_floor():
				transitionToState.emit("F_IDLE")

func _aim_tongue(delta: float):
	#awesome cosine function for moving the tongue back and forth
	_time += delta
	_curr_angle = cos(_time * rotation_speed) * deg_to_rad(max_angle)
	player.tongue.rotation = _curr_angle
	player.tongue.tip.rotation = -_curr_angle #tip faces straight up
	
	if Input.is_action_just_released("bite_dash"): #release button to fire tongue
		_dash_state = "shoot"
		player.tongue.monitor_tip_area()

# Rapidly moves tongue tip at tongue angle
# (the whole tongue node is rotated, so the tip's relative y position is moved)
func _shoot_tongue(delta: float):
	player.tongue.move_tip(tip_speed * delta)
	if player.tongue.tip.position.y <= -tongue_length: #switch to idle if tip hits nothing
		transitionToState.emit("F_IDLE")
		
func _tip_touch_surface(body : Node2D):
	_pull_direction = Vector2(sin(_curr_angle) * player.previous_direction, -cos(_curr_angle)) 
	if _dash_state == "pull":
		return
	if (body is TileMapLayer): # wall or ceiling usually
		_dash_state = "pull"
		if !player.tongue.is_raycast_colliding(): #angle the velocity higher if grabbing onto a ledge
			_pull_direction.y -= _curr_angle/2
			_is_mantling = true 
		player.tongue.hide_tongue()
		print(rad_to_deg(_curr_angle))
		print(rad_to_deg(_pull_direction.x/_pull_direction.y))
		print(_is_mantling)
	if (body is Animal):
		pass #TODO make it so animals are pulled toward the player

func _pull_frog(delta: float):
	player.velocity = player.velocity.move_toward(_pull_direction.normalized() * pull_speed, delta * pull_speed)
	var _current_distance = _starting_position - player.global_position
	if player.is_on_wall() || player.is_on_ceiling(): #when a player hits a tile surface
		transitionToState.emit("F_IDLE")
	if _current_distance.length() >= tongue_length && _is_mantling: #mantle when distance moved is equal to tongue length and you're amntling
		#.length() is magnitude of a Vector2 btw
		_dash_state = "mantle"
		_mantle_scalar = mantle_impulse if _pull_direction.x > 0 else -mantle_impulse #impulse direction
		var _mar = deg_to_rad(mantle_angle) #mantle angle (in) radians
		player.velocity = player.velocity.length() * ( Vector2(cos(_mar), -sin(_mar)) if _pull_direction.x > 0
					else Vector2(-cos(_mar), -sin(_mar) ) )



func exit_state():
	player.tongue.hide_tongue()
