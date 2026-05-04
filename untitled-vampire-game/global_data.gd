extends Node

enum Animals {FROG, RAT}

var blood_chamber : Array[Animals]
var charges : int

var animals_remaining : int
var level_complete : bool = false

signal update_animals_remaining
signal update_blood_chamber

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

func blood_collected(animal : Area2D):
	blood_chamber.push_front(animal.type)
	if (blood_chamber.size() > 3):
		blood_chamber.resize(3)
	return
	
func blood_cycle():
	if (blood_chamber.size() <= 1):
		print("global_data.gd: blood_cycle() -- attemped to blood_cycle with array <= 1; cycling requires 2 or more tokens")
		return
	
	var token = blood_chamber.pop_front()
	blood_chamber.push_back(token)
	update_blood_chamber.emit()
	# Updating UI currently initiated from the action in Player.gd
	# Currently unsure if/how to connect the blood_container to this global_data.gd
	return

func next_level(level : PackedScene):
	blood_chamber.clear()
	charges = 0
	get_tree().change_scene_to_packed(level)
