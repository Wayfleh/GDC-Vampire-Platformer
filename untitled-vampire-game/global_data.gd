extends Node

enum Animals {FROG}

var blood_chamber : Array[Animals]
var charges : int

var animals_remaining : int
var level_complete : bool = false

signal update_animals_remaining

func start_level() -> void:
	print("LEVEL MANAGER READY IN SCENE:", get_tree().current_scene.name)
	animals_remaining = get_tree().get_nodes_in_group("animals").size()
	print("Animals in level:", animals_remaining)

func animal_bitten():
	animals_remaining -= 1
	print("Animals left:", animals_remaining)
	update_animals_remaining.emit()
	
	if animals_remaining <= 0:
		level_complete = true

func next_level(level : PackedScene):
	blood_chamber.clear()
	charges = 0
	get_tree().change_scene_to_packed(level)
