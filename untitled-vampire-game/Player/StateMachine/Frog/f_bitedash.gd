## FROG
extends State

@export var tongue_length: float = 80.0
@export var rotation_speed: float
@export var tip_speed: float
@export_range(0, 90, 0.1, "suffix: deg") var max_angle: float
@export var pull_speed: float = 2000.0

var _dash_state : String # aim, shoot, pull
var _time : float
var _pull_direction : Vector2 
var _curr_angle : float

func enter_state():
	#initialize tongue stuff
	player.tongue.rotation = max_angle
	player.tongue.tip.monitoring = true
	player.tongue.tip.position.y = 0.0
	player.tongue.show()
	_time = 0.0
	player.tongue.tip.body_entered.connect(_tip_touch_surface) #TODO find a way to put this in a _ready() function without node hierarchy shit getting in the way

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

func _aim_tongue(delta: float):
	#awesome cosine function for moving the tongue back and forth
	_time += delta
	_curr_angle = cos(_time * rotation_speed) * deg_to_rad(max_angle)
	player.tongue.rotation = _curr_angle
	
	if Input.is_action_just_released("bite_dash"): #release button to fire tongue
		_dash_state = "shoot"

# Rapidly moves tongue tip at tongue angle
# (the whole tongue node is rotated, so the tip's relative y position is moved)
func _shoot_tongue(delta: float):
	player.tongue.move_tip(tip_speed * delta)
	if player.tongue.tip.position.y <= -tongue_length: #switch to idle if tip hits nothing
		transitionToState.emit("F_IDLE")

func _pull_frog(delta: float):
	player.velocity = player.velocity.move_toward(_pull_direction.normalized() * pull_speed, delta * pull_speed)
	if (player.is_on_wall()) || player.is_on_ceiling(): #when a player hits a tile surface
		transitionToState.emit("F_IDLE")

func _tip_touch_surface(body : Node2D):
	_pull_direction = Vector2(sin(_curr_angle) * player.previous_direction, -cos(_curr_angle)) 
	if _dash_state == "pull":
		return
	if (body is TileMap): # wall or ceiling usually
		_dash_state = "pull"
		_hide_tongue()
	if (body is Animal):
		pass #TODO make it so animals are pulled toward the player

# Gets called by above and below functions
func _hide_tongue():
	player.tongue.hide()
	player.tongue.tip.monitoring = false

func exit_state():
	_hide_tongue()
