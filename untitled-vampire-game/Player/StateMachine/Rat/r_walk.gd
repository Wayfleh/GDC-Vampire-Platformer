extends State

var coyote_timer: Timer

func enter_state():
	player.anim_sprite.play("rat_walk")
	coyote_timer = Timer.new()
	coyote_timer.wait_time = 0.1
	coyote_timer.autostart = false
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)

func update(delta: float):
	
	player.apply_friction(delta, 10)
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.velocity.x == 0:
		transitionToState.emit("R_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.can_jump:
		transitionToState.emit("R_JUMP")
		player.can_jump = false
	
	if !player.can_jump && player.is_on_floor():
		player.can_jump = true
	if !player.is_on_floor() && coyote_timer.is_stopped():
		coyote_timer.start()
	
	player.apply_footsteps(delta)

func _on_coyote_timer_timeout():
	player.can_jump = false

func exit_state():
	player.anim_sprite.stop()
