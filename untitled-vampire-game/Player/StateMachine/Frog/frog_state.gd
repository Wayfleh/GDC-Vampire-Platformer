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
@export var F_SPEED := 200.0
@export var F_JUMP_IMPULSE := 700.0
@export var F_GRAVITY := 3000.0
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
