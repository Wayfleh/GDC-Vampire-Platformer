extends Control

@onready var resume_button: Button = $Buttons/Resume
@onready var restart_button: Button = $Buttons/Restart
@onready var main_menu_button: Button = $"Buttons/Main Menu"

func _ready() -> void:
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(restart)
	main_menu_button.pressed.connect(main_menu)

func pause() -> void:
	get_tree().paused = true

func resume() -> void:
	get_tree().paused = false
	hide()

func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
