class_name Player
extends CharacterBody2D

#change speed, jump height, and gravity
@export var SPEED: float = 5.0
@export var JUMP_IMPULSE: float = 5.0
@export var GRAVITY: float = 5.0

@onready var state_machine := $StateMachine

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide() # this just turns all the velocity bullshit into actual movement

func handle_gravity(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta

func handle_movement(delta: float):
	var direction = Input.get_axis("left", "right")
	velocity.x = SPEED * 100 * direction * delta
