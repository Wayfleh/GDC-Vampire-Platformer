## FROG
extends State

@export var _walk_hop_impulse : float = 350.0

var hopIndex = 0
@onready var sound_f_hop_2: AudioStreamPlayer2D = $"../../../../SoundF_Hop2"
@onready var sound_f_hop_1: AudioStreamPlayer2D = $"../../../../SoundF_Hop1"

func enter_state():
	#TODO fix the current_direction bullshit in player so it doesn't change the scale of the nodes at all, cause that's gonna mess with stuff later
	player.anim_sprite.play("frog_walk_right")

func update(delta: float):
	if player.is_on_floor():
		_hop()
	
	player.apply_friction(delta, 10)
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.direction == 0:
		transitionToState.emit("F_IDLE")
	
	if Input.is_action_just_pressed("jump"):
		transitionToState.emit("F_JUMP")

func _hop():
	player.velocity.y -= _walk_hop_impulse

func playHopSound():
	hopIndex = hopIndex + 1
	match fmod(hopIndex,2):
		0:
			sound_f_hop_1.play()
		1:
			sound_f_hop_2.play()
		_:
			sound_f_hop_1.play()

func exit_state():
	pass
