extends State

#Constants for frog state
var F_SPEED := 200.0
var F_JUMP_IMPULSE := 700.0
var F_GRAVITY := 3000.0
@onready var f_machine = $FrogSM

#turn on processing for statemachine
#set player constants to vampire constants

func enter_state():
	f_machine.set_process(true)
	f_machine.begin_state_machine(f_machine.initial_state)
	player.speed = F_SPEED
	player.jump_impulse = F_JUMP_IMPULSE
	player.gravity = F_GRAVITY
	
func update(delta: float):
	if Input.is_action_just_pressed("test_frog_transform(REMOVE LATER)"):
		transitionToState.emit("VAMPIRE")

#turn off processing for statemachine
func exit_state():
	f_machine.set_process(false)
