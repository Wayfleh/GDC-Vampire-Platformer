## VAMPIRE
extends State

@export var fastFallGravityMultiplier: float = 1.5 #When the player isn't pressing the jump button, fall faster.
@onready var jump_sound: AudioStreamPlayer2D = $"../../../../JumpSound"
@onready var min_jump_timer: Timer 

func enter_state():
	min_jump_timer = Timer.new()
	min_jump_timer.wait_time = 0.1
	min_jump_timer.autostart = false
	min_jump_timer.one_shot = true
	add_child(min_jump_timer)
	min_jump_timer.timeout.connect(_jump_timer_stopped)
	min_jump_timer.start()
	
	player.anim_sprite.play("vampire_jump")
	player.velocity.y = -player.jump_impulse
	jump_sound.play()

func update(delta: float):
	player.apply_horizontal_movement(delta)
	if Input.is_action_just_released("jump") && player.velocity.y <= 0:
		if !min_jump_timer:
			player.velocity.y = 0
	player.apply_gravity(delta, 1)
	
	if player.is_on_floor() and !Input.is_action_just_pressed("jump"):
		transitionToState.emit("V_IDLE")
	
	if player.velocity.y > 0 && !player.is_on_floor():
		player.anim_sprite.play("vampire_fall")
	
	# can only bite dash once in the air
	if (Input.is_action_just_pressed("bite_dash") 
	&& !player.bite_dash_used):
		transitionToState.emit("V_BITEDASH")

func _jump_timer_stopped():
	if !Input.is_action_pressed("jump") && player.velocity.y <= 0:
		player.velocity.y = 0
	min_jump_timer.queue_free()

func exit_state():
	player.can_jump = true
