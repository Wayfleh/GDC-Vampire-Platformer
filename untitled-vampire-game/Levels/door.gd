extends Node2D

@onready var door_area: Area2D = $DoorArea
@onready var animal_number: Label = $AnimalNumber
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.start_level()
	door_area.body_entered.connect(check_level_complete)

func check_level_complete(body: Node2D):
	if body is Player && GlobalData.animals_remaining == 0:
		
		GlobalData.next_level()

func _process(delta: float) -> void:
	animal_number.text = str(GlobalData.animals_remaining)
