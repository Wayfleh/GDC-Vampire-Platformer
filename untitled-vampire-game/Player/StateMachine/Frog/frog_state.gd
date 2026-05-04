extends State
"""
Frog can:
	Bite Dash - Tonguelash:
			Fire out tongue, on contact:
				- Pull yourself towards terrain
				- Pull animals toward yourself (and bite them)
	Ability - Big Jump
			- Regular ah jump, but much taller
			- Potentially Jump King jump
	Walk - Walking hops -> Slides when stopping
"""
#Constants for frog state
@export var F_SPEED := 50.0
@export var F_JUMP_IMPULSE := 700.0
@export var F_GRAVITY := 3000.0
@export var F_FRICTION := 1.0
@onready var f_machine: StateMachine = $FrogSM

@onready var jump_charges: int
@export var frog_sprite_sheet: Texture2D

#turn on processing for statemachine
#set player constants to vampire constants

func enter_state():
	f_machine.set_physics_process(true)
	f_machine.begin_state_machine(f_machine.initial_state)
	jump_charges = 2
	player.speed = F_SPEED
	player.jump_impulse = F_JUMP_IMPULSE
	player.gravity = F_GRAVITY
	player.friction = F_FRICTION
	
	player.detransform.connect(_transform_to_vampire)
	# player.isTransformed = true
	
func update(delta: float):
	if f_machine.current_state != f_machine.states["F_BITEDASH"]: 
		player.apply_input_direction(delta) #don't apply direction in bitedash
		
		if Input.is_action_pressed("bite_dash"):
			f_machine.change_state("F_BITEDASH")
	
		if Input.is_action_just_pressed("transform"):
			player.TransformToVampire()
	# Detransforming can only be available the frame AFTER pressing the transform button.
	# Please let me know if there's a better way of doing this. Other solutions I've tried
	#	end up transforming and detransforming within the same frame.
	#if player.isTransformed == false:
	#	player.isTransformed = true

func _transform_to_vampire():
	transitionToState.emit("VAMPIRE")

#turn off processing for statemachine
func exit_state():
	f_machine.set_physics_process(false)
