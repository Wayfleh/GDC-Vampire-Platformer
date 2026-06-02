extends Node

var key_1_held := false
var key_2_held := false

var quit_hold_time := 0.0
const HOLD_REQUIRED := 1.0

func _ready() -> void:
	print("ArcadeQuit autoload is running")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.physical_keycode == KEY_1 or event.keycode == KEY_1:
			key_1_held = event.pressed
			print("key 1 held: ", key_1_held)

		if event.physical_keycode == KEY_2 or event.keycode == KEY_2:
			key_2_held = event.pressed
			print("key 2 held: ", key_2_held)

func _process(delta: float) -> void:
	if key_1_held and key_2_held:
		quit_hold_time += delta
		print("both held: ", quit_hold_time)

		if quit_hold_time >= HOLD_REQUIRED:
			print("quitting now")
			get_tree().quit()
	else:
		quit_hold_time = 0.0
