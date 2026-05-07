class_name Door extends Node2D


@onready var door_area: Area2D = $DoorArea
@onready var animal_number: Label = $AnimalNumber
@onready var door_sprite: AnimatedSprite2D = $DoorSprite
@onready var open_sound: AudioStreamPlayer2D = $openSound

@export var player_face_left_on_start: bool = false
####
# make sure the level you load can't end up looping back into 
# the current level through other doors, or else this variable is null.
# The editor doesn't tag the circular reference if it's hidden in
# another level.
####

var door_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player_face_left_on_start:
		$"../Player".previous_direction = -1
		$"../Player/CurrentDirection".scale.x = -1
	GlobalData.start_level()
	GlobalData.update_animals_remaining.connect(update_animal_number)
	door_area.body_entered.connect(check_level_complete)

	# start closed
	door_sprite.play("closed")
	# if there are no animals at start of level, start the level with door open and skip opening sound
	if (GlobalData.animals_remaining == 0 and not door_open):
		door_open = true
		door_sprite.play("open")
		print("door opening -- no Animals in level")

	update_animal_number()
	
	

func check_level_complete(body: Node2D) -> void:
	if body is Player and door_open:
		GlobalData.next_level()

func update_animal_number() -> void:
	animal_number.text = str(GlobalData.animals_remaining)

	if GlobalData.animals_remaining == 0 and not door_open:
		open_door()
		

func open_door() -> void:
	door_open = true
	door_sprite.play("open")
	open_sound.play()
	print("door opening")
