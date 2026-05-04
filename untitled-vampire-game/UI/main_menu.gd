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
	GlobalMusic.ChangeTrack("main_menu")
	sequence_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.is_action(chinese_sequence[sequence_index]):
			sequence_index += 1
			print(sequence_index)
			if sequence_index >= chinese_sequence.size():
				get_tree().change_scene_to_file("res://Levels/raflevels/raf_level2_chinese.tscn")
		else:
			sequence_index = 0


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Misc/opening_cutscene.tscn")
	GlobalMusic.ChangeTrack("overworld")
#goes to level01 if pressed


func _on_quit_button_2_pressed() -> void:
	get_tree().quit()
