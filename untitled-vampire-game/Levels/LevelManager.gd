extends Node

var animals_remaining : int
var level_complete : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("level_manager")
	
	animals_remaining = get_tree().get_nodes_in_group("animals").size()
	print("Animals in level:", animals_remaining)

func animal_bitten():
	animals_remaining -= 1
	print("Animals left:", animals_remaining)

	if animals_remaining <= 0:
		level_complete = true
		print("Level Complete! Press Enter")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_complete and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Levels/Level_02.tscn")
