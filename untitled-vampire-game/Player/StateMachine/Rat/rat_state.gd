extends State

@export var R_SPEED := 100.0
@export var R_JUMP_IMPULSE := 200.0
@export var R_GRAVITY := 1500.0
@export var R_FRICTION := 10.0
@onready var r_machine = $RatSM



#turn on processing for statemachine
#set player constants to vampire constants
func enter_state():
	r_machine.set_physics_process(true)
	r_machine.begin_state_machine(r_machine.initial_state)
	player.rat_hole_interactor.monitoring = true
	player.speed = R_SPEED
	player.jump_impulse = R_JUMP_IMPULSE
	player.gravity = R_GRAVITY
	player.friction = R_FRICTION
	
	player.detransform.connect(_transform_to_vampire)

func update(delta: float):
	if r_machine.current_state != r_machine.states["R_BITEDASH"]: #don't apply direction in bitedash
		player.apply_input_direction(delta)
		if (Input.is_action_just_pressed("bite_dash")):
			r_machine.change_state("R_BITEDASH")
	
	# Detransforming can only be available the frame AFTER pressing the transform button.
	# Please let me know if there's a better way of doing this. Other solutions I've tried
	#	end up transforming and detransforming within the same frame.
	if player.isTransformed == false:
		player.isTransformed = true

func _transform_to_vampire():
	transitionToState.emit("VAMPIRE")

#turn off processing for statemachine
func exit_state():
	r_machine.set_physics_process(false)
	player.rat_hole_interactor.monitoring = false
