extends Control

@onready var scroll: ScrollContainer = $Scroller
@export var scroll_speed: int = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func goToNext():
	get_tree().change_scene_to_file("res://Levels/Level_01.tscn")
	
func _process(delta: float) -> void:
	scroll.scroll_vertical += scroll_speed * delta
	
	if (scroll.scroll_vertical >= scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page
	or Input.is_anything_pressed()):
		goToNext()
