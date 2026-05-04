extends State

#Constants for vampire state
@export var V_SPEED := 100.0
@export var V_JUMP_IMPULSE := 500.0
@export var V_GRAVITY := 1500.0
@export var V_FRICTION := 10.0
@onready var v_machine = $VampireSM

@onready var sound_f_transform: AudioStreamPlayer2D = $"../../SoundF_Transform"

var trans_buffer_timer: Timer
@onready var current_chamber_size: int


#turn on processing for statemachine
#set player constants to vampire constants
func enter_state():
	v_machine.set_physics_process(true)
	v_machine.begin_state_machine(v_machine.initial_state)
	player.speed = V_SPEED
	player.jump_impulse = V_JUMP_IMPULSE
	player.gravity = V_GRAVITY
	player.friction = V_FRICTION
	player.collider.disabled = false
	player.collider_rat.disabled = true
	player.isTransformed = false
	
	trans_buffer_timer = Timer.new()
	trans_buffer_timer.wait_time = .2
	trans_buffer_timer.autostart = false
	trans_buffer_timer.one_shot = true
	add_child(trans_buffer_timer)
	GlobalData.update_animals_remaining.connect(check_buffer)
	
	
	
func update(delta: float):
	if Input.is_action_just_pressed("transform") && !player.isTransformed:
		# transform vampire into frog if vampire has frog blood and is not
		#currently a frog
		if (v_machine.current_state != v_machine.states["V_BITEDASH"]) && !GlobalData.blood_chamber.is_empty():
			transform()
		else:
			current_chamber_size = GlobalData.blood_chamber.size()
			trans_buffer_timer.start()
		player.UpdateUI()
	if player.is_on_floor():
		player.bite_dash_used = false
	if v_machine.current_state != v_machine.states["V_BITEDASH"]: #don't apply direction in bitedash
		player.apply_input_direction(delta)

func check_buffer():
	if !trans_buffer_timer.is_stopped(): #if, during the buffer's duration, you get blood, transform
		transform()
	current_chamber_size = 0

func transform():
	player.isTransformed = true
	player.playPoofParticle()
	if (v_machine.current_state == v_machine.states["V_BITEDASH"]):
		v_machine.current_state.exit_state() #control the velocity of the bitedash
	# remove front of chamber and save it
	var current_blood = GlobalData.blood_chamber.pop_front() 
	match current_blood:
		GlobalData.Animals.FROG:
			sound_f_transform.play()
			transitionToState.emit("FROG")
		GlobalData.Animals.RAT:
			transitionToState.emit("RAT")
#turn off processing for statemachine
func exit_state():
	v_machine.current_state = v_machine.initial_state
	v_machine.set_physics_process(false)
	player.afterimage_particles.emitting = false
