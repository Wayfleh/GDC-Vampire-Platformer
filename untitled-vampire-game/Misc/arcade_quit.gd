extends Node

var quit_hold_time:= 0.0
const HOLD_REQUIRED := 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float)
	var key_1_pressed = Input.is.physical_key_pressed(KEY_1)
	var key_2_pressed = Input.is.physical_key_pressed(KEY_2)
	
	if key_1_pressed and key_2_pressed:
		quit_hold_time += delta
		
	if quit_hold_time >= HOLD_REQUIRED:
		get_tree().quit()
	else:
		quit_hold_time = 0.0
