extends CanvasLayer

@onready var pause_menu = $"Pause Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == false:
			pause_menu.show()
			pause_menu.pause()
		elif get_tree().paused == true:
			pause_menu.hide()
			pause_menu.resume()
	

func GetBloodContainerNode():
	return $BloodContainer
