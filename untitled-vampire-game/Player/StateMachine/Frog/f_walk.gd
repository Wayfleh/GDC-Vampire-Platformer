## FROG
extends State

@export var _walk_hop_impulse : float = 350.0

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

func exit_state():
	pass
