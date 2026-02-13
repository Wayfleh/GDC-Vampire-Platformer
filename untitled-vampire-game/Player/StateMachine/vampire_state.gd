extends State

#Constants for vampire state
@export var V_SPEED := 500.0
@export var V_JUMP_IMPULSE := 1400.0
@export var V_GRAVITY := 3000.0
@onready var v_machine = $VampireSM

#turn on processing for statemachine
#set player constants to vampire constants
func enter_state():
	v_machine.set_process(true)
	v_machine.begin_state_machine(v_machine.initial_state)
	player.speed = V_SPEED
	player.jump_impulse = V_JUMP_IMPULSE
	player.gravity = V_GRAVITY
	
func update(delta: float):
	if Input.is_action_just_pressed("test_frog_transform(REMOVE LATER)"):
		transitionToState.emit("FROG")

#turn off processing for statemachine
func exit_state():
	v_machine.current_state = v_machine.initial_state
	v_machine.set_process(false)
