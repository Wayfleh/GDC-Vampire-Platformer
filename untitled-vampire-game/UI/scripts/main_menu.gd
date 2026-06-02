extends Control

var chinese_sequence = [
	"up",
	"up",
	"up",
	"down",
	"down",
	"up",
	"right",
	"jump",
	"bite_dash"
]

var sequence_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.curr_level_index = -1
	GlobalData.challenge = false
	GlobalData.curr_path = GlobalData.levels_path
	GlobalData.levels = GlobalData.level_files
	GlobalMusic.ChangeTrack("main_menu")
	sequence_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.is_action(chinese_sequence[sequence_index]):
			sequence_index += 1
			print(sequence_index)
			if sequence_index >= chinese_sequence.size():
				GlobalData.challenge = true
				GlobalData.curr_path = GlobalData.ch_levels_path
				GlobalData.levels = GlobalData.ch_level_files
				GlobalMusic.ChangeTrack("challenge")
				GlobalData.next_level()
		else:
			sequence_index = 0


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Misc/opening_cutscene.tscn")
	GlobalMusic.ChangeTrack("overworld")
	GlobalMusic.SFX_Bookhit()
#goes to level01 if pressed


func _on_quit_button_2_pressed() -> void:
	GlobalMusic.SFX_Bookhit()
	await get_tree().create_timer(GlobalMusic.sfx_bookhit.stream.get_length()).timeout
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	GlobalMusic.SFX_Bookhit()
	get_tree().change_scene_to_file("res://UI/credits.tscn") # Replace with function body.
