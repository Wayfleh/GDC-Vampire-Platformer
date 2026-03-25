class_name Door extends Node2D

@onready var door_area: Area2D = $DoorArea
@onready var animal_number: Label = $AnimalNumber

@export var next_level: PackedScene #Loads the next level
####
# make sure the level you load can't end up looping back into 
# the current level through other doors, or else this variable is null.
# The editor doesn't tag the circular reference if it's hidden in
# another level.
####

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalData.start_level()
	GlobalData.update_animals_remaining.connect(update_animal_number)
	update_animal_number()
	door_area.body_entered.connect(check_level_complete)

func check_level_complete(body: Node2D):
	if body is Player && GlobalData.animals_remaining == 0:
		
		GlobalData.next_level(next_level)

func update_animal_number():
	animal_number.text = str(GlobalData.animals_remaining)
