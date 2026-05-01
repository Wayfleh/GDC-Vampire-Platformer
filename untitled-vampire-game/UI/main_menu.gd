extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalMusic.ChangeTrack("main_menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Misc/opening_cutscene.tscn")
	GlobalMusic.ChangeTrack("overworld")
#goes to level01 if pressed


func _on_quit_button_2_pressed() -> void:
	get_tree().quit()
