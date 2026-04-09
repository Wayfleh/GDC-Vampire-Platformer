extends Control

@onready var resume_button: Button = $Buttons/Resume
@onready var restart_button: Button = $Buttons/Restart
@onready var main_menu_button: Button = $"Buttons/Main Menu"
@onready var custom_keybinds_button: Button = $Buttons/CustomKeybinds
@onready var reset_defaults_button: Button = $Buttons/ResetDefaults
@onready var rebind_status: Label = $RebindStatus


var actions_to_rebind: Array[String] = [
	"left",
	"right",
	"jump",
	"bite_dash",
	"restart",
	"blood_cycle",
	"transform"
]


var default_bindings := {}


var is_rebinding: bool = false
var current_rebind_index: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(restart)
	main_menu_button.pressed.connect(main_menu)
	custom_keybinds_button.pressed.connect(start_rebinding)
	reset_defaults_button.pressed.connect(reset_to_defaults)

	store_default_bindings()

	rebind_status.text = ""


func pause() -> void:
	get_tree().paused = true
	show()


func resume() -> void:
	get_tree().paused = false
	hide()
	is_rebinding = false
	rebind_status.text = ""


func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")


func store_default_bindings() -> void:
	default_bindings.clear()
	
	default_bindings["left"] = [make_key_event(KEY_A)]
	default_bindings["right"] = [make_key_event(KEY_D)]
	default_bindings["jump"] = [make_key_event(KEY_W)]
	default_bindings["bite_dash"] = [make_key_event(KEY_J)]
	default_bindings["restart"] = [make_key_event(KEY_R)]
	default_bindings["blood_cycle"] = [make_key_event(KEY_Q)]
	default_bindings["transform"] = [make_key_event(KEY_E)]

func make_key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	return event


func start_rebinding() -> void:
	is_rebinding = true
	current_rebind_index = 0
	show_next_action_prompt()


func show_next_action_prompt() -> void:
	if current_rebind_index >= actions_to_rebind.size():
		is_rebinding = false
		rebind_status.text = "Rebinding Done."
		return

	var action_name := actions_to_rebind[current_rebind_index]
	rebind_status.text = "Press a key/button for: " + action_name


func _input(event: InputEvent) -> void:
	if !is_rebinding:
		return

	if event is InputEventKey and event.pressed:
		rebind_current_action(event)
	elif event is InputEventJoypadButton and event.pressed:
		rebind_current_action(event)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
		rebind_current_action(event)


func rebind_current_action(event: InputEvent) -> void:
	var action_name := actions_to_rebind[current_rebind_index]

	InputMap.action_erase_events(action_name)

	InputMap.action_add_event(action_name, event)

	current_rebind_index += 1
	show_next_action_prompt()
	

func reset_to_defaults() -> void:
	for action in actions_to_rebind:
		InputMap.action_erase_events(action)

		for event in default_bindings[action]:
			InputMap.action_add_event(action, event.duplicate())

	rebind_status.text = "Controls reset to default."
	is_rebinding = false
