extends Control

@onready var skip_timer: Timer = $SkipTimer
@onready var press_any: Label = $PressAnyButton
var can_skip: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_skip = false
	press_any.hide()
	skip_timer.timeout.connect(_you_can_skip_now)

func _you_can_skip_now():
	can_skip = true
	press_any.show()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and can_skip:
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
