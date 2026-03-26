extends State

#Constants for vampire state
@export var V_SPEED := 100.0
@export var V_JUMP_IMPULSE := 500.0
@export var V_GRAVITY := 1500.0
@export var V_FRICTION := 10.0
@onready var v_machine = $VampireSM


#turn on processing for statemachine
#set player constants to vampire constants
func enter_state():
	v_machine.set_physics_process(true)
	v_machine.begin_state_machine(v_machine.initial_state)
	player.speed = V_SPEED
	player.jump_impulse = V_JUMP_IMPULSE
	player.gravity = V_GRAVITY
	player.friction = V_FRICTION
	
func update(delta: float):
	if Input.is_action_just_pressed("test_frog_transform(REMOVE LATER)"):
		# transform vampire into frog if vampire has frog blood and is not
		#currently a frog
		if GlobalData.blood_chamber.is_empty():
			return
		# remove front of chamber and save it
		var current_blood = GlobalData.blood_chamber.pop_front() 
		if (current_blood == GlobalData.Animals.FROG 
		&& v_machine.current_state != v_machine.states["V_BITEDASH"]):
			transitionToState.emit("FROG")
		player.UpdateUI()
	if player.is_on_floor():
		player.bite_dash_used = false
	if v_machine.current_state != v_machine.states["V_BITEDASH"]: #don't apply direction in bitedash
		player.apply_input_direction(delta)

#turn off processing for statemachine
func exit_state():
	v_machine.current_state = v_machine.initial_state
	v_machine.set_physics_process(false)
