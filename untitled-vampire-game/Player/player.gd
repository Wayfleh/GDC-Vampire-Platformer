class_name Player
extends CharacterBody2D

#change speed, jump height, and gravity
@export var speed: float = 5.0
@export var jump_impulse: float = 5.0
@export var gravity: float = 5.0

@onready var state_machine := $StateMachine

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide() # this just turns all the velocity bullshit into actual movement
					# move_and_slide() is a CharacterBody2D Function

func apply_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

func apply_horizontal_movement(delta: float):
	var direction = Input.get_axis("left", "right")
	velocity.x = speed * 100 * direction * delta
