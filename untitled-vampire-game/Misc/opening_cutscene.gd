extends Control

@onready var scroll: ScrollContainer = $Scroller
@export var scroll_speed: int = 100

var curr_scroll: float = 0
var button_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _process(delta: float) -> void:
	curr_scroll += scroll_speed * delta
	if floor(curr_scroll) >= 1:
		scroll.scroll_vertical += 1
		curr_scroll = 0
	
	if scroll.scroll_vertical >= scroll.get_v_scroll_bar().max_value - scroll.get_v_scroll_bar().page:
		GlobalData.next_level()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey && !button_pressed:
		button_pressed = true
		GlobalMusic.SFX_Bookhit()
		await get_tree().create_timer(GlobalMusic.sfx_bookhit.stream.get_length()).timeout
		GlobalData.next_level()
