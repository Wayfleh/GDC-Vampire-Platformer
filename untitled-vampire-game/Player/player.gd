class_name Player
extends CharacterBody2D

#change speed, jump height, and gravity
@export var speed: float = 5.0
@export var jump_impulse: float = 5.0
@export var gravity: float = 5.0

@export var biteDashDirection: Vector2
var previousPosition: Vector2 #Velocity value in previous frame. Used for calculating Bite Dash Direction

@onready var state_machine := $StateMachine

func _ready() -> void:
	biteDashDirection = Vector2(1,0)
	previousPosition = Vector2(0,0)
	pass

func _physics_process(delta: float) -> void:
	move_and_slide() # Applies velocity to the in-game object
	biteDashDirection = DetermineBiteDashDirection(position, previousPosition, biteDashDirection)
	previousPosition = position
					# move_and_slide() is a CharacterBody2D Function

func apply_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

func apply_horizontal_movement(delta: float):
	var direction = Input.get_axis("left", "right")
	velocity.x = speed * 100 * direction * delta

# Using player velocity to determine Bite Dash facing direction
# DetermineBiteDashDirection() takes biteDashDirection as an argument, so it can 
#		pass itself (and remain the same) if there is no change in position
func DetermineBiteDashDirection(currPos: Vector2, prevPos: Vector2, biteDashDirection: Vector2):
	if (currPos == null || prevPos == null):
		print("Player.gd: DetermineBiteDashDirection() - current or previous position is null?")
		print(currPos)
		print(prevPos)
		return Vector2(1,0)
	if (currPos == prevPos):
		return biteDashDirection
	var dir = (currPos - prevPos).normalized()
	print(dir)
	return dir
