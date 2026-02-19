class_name Player
extends CharacterBody2D

#change speed, jump height, and gravity
var speed: float = 5.0
var jump_impulse: float = 1.0
var gravity: float = 5.0

@export var bite_dash_direction: Vector2
var previous_position: Vector2 #Velocity value in previous frame. Used for calculating Bite Dash Direction

@onready var state_machine := $StateMachine

func _ready() -> void:
	bite_dash_direction = Vector2(1,0)
	previous_position = Vector2(0,0)
	pass

func _physics_process(delta: float) -> void:
	move_and_slide() # Applies velocity to the in-game object
	bite_dash_direction = DetermineBiteDashDirection(position, previous_position, bite_dash_direction)
	previous_position = position
					# move_and_slide() is a CharacterBody2D Function

func apply_gravity(delta: float, multiplier: float = 1.0) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta * multiplier

func apply_horizontal_movement(delta: float):
	var direction = Input.get_axis("left", "right")
	velocity.x = speed * 100 * direction * delta

# Using player velocity to determine Bite Dash facing direction
# DetermineBiteDashDirection() takes bite_dash_direction as an argument, so it can 
#		pass itself (and remain the same) if there is no change in position
func DetermineBiteDashDirection(currPos: Vector2, prevPos: Vector2, bite_dash_direction: Vector2):
	if (currPos == null || prevPos == null):
		print("Player.gd: DetermineBiteDashDirection() - current or previous position is null?")
		print(currPos)
		print(prevPos)
		return Vector2(1,0)
	if (currPos == prevPos):
		return bite_dash_direction
	var dir = (currPos - prevPos).normalized()
	# print(dir)
	return dir
