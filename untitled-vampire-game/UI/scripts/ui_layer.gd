extends CanvasLayer

@onready var pause_menu = $"Pause Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "Level " + ("0" if GlobalData.curr_level_index < 9 else "") + str(GlobalData.curr_level_index + 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("ui_cancel"):
		if get_tree().paused == false:
			pause_menu.pause()
		elif get_tree().paused == true:
			pause_menu.resume()
	

func GetBloodContainerNode():
	return $BloodContainer
