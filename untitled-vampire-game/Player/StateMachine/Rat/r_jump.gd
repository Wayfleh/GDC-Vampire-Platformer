extends State

var teleporting: bool

# Called when the node enters the scene tree for the first time.
func enter_state():
	player.anim_sprite.play("rat_walk")
	player.velocity.y -= player.jump_impulse


func update(delta: float):
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta, 1.0)
	
	var areas: Array[Area2D] = player.rat_hole_interactor.get_overlapping_areas()
	
	if !teleporting:
		for area in areas:
			if area is Hole: 
				#below block happens only once, so you can just call a method too
				player.global_position = area.ratTeleport()
				teleporting = true
	
	if player.is_on_floor() and !Input.is_action_just_pressed("jump"):
		transitionToState.emit("R_IDLE")

func exit_state():
	teleporting = false
