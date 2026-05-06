## VAMPIRE
extends State
var coyote_timer: Timer

func enter_state():
	coyote_timer = Timer.new()
	coyote_timer.wait_time = 0.1
	coyote_timer.autostart = false
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(_on_coyote_timer_timeout)
	if player.is_on_floor():
		if player.bd_sprite_timer.is_stopped():
			player.anim_sprite.play("vampire_walk")
	else:
		player.anim_sprite.play("vampire_fall")
	#walk animation

func update(delta: float):
	
	player.apply_friction(delta, 10)
	player.apply_horizontal_movement(delta)
	player.apply_gravity(delta)
	
	if player.anim_sprite.animation != "vampire_walk" && player.is_on_floor() && player.bd_sprite_timer.is_stopped():
		#&& (you're buns at the game)
		player.anim_sprite.play("vampire_walk")
	
	if player.velocity.x == 0:
		transitionToState.emit("V_IDLE")
	
	if Input.is_action_just_pressed("jump") and player.can_jump:
		transitionToState.emit("V_JUMP")
		player.can_jump = false
	
	if !player.can_jump && player.is_on_floor():
		player.can_jump = true
	if !player.is_on_floor() && coyote_timer.is_stopped():
		coyote_timer.start()
	
	if (Input.is_action_just_pressed("bite_dash") 
	&& !player.bite_dash_used):
		transitionToState.emit("V_BITEDASH")

func _on_coyote_timer_timeout():
	player.can_jump = false

func exit_state():
	coyote_timer.queue_free()
	player.anim_sprite.stop()
