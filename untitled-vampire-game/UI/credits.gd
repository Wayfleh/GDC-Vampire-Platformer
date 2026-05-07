extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Return.label.text = "Return"
	$Return.pressed.connect(return_to_main_menu)

func return_to_main_menu():
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
