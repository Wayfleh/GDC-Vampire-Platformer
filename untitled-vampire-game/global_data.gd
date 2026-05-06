extends Node

enum Animals {FROG, RAT}

var blood_chamber : Array[Animals]
var charges : int

var animals_remaining : int
var level_complete : bool = false
var restarted: bool = false

var levels_path: String = "res://Levels/FinalLevels"
var ch_levels_path: String = "res://Levels/ChallengeLevels/"

var curr_path: String = levels_path

var level_files: PackedStringArray
var ch_level_files: PackedStringArray

var levels: PackedStringArray = level_files

var challenge: bool = false
var curr_level_index: int = -1

var hilarious_blood_chamber_bit: bool = false

signal update_animals_remaining
signal update_blood_chamber
signal do_the_bit

func _ready() -> void:
	hilarious_blood_chamber_bit = false
	level_files = DirAccess.get_files_at(levels_path)
	ch_level_files = DirAccess.get_files_at(ch_levels_path)

#FOR DEBUGGING ONLY, TAKE THIS OUT LATER
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_next_level"):
		next_level()
		print(curr_level_index + 1)

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
	if hilarious_blood_chamber_bit && blood_chamber.size() == 3:
		do_the_bit.emit()
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

func next_level():
	blood_chamber.clear()
	charges = 0
	curr_level_index += 1
	if challenge && curr_level_index == levels.size() - 1:
		hilarious_blood_chamber_bit = true
	if curr_level_index >= levels.size():
		var last_scene = "res://UI/MainMenu.tscn" if challenge else "res://Misc/cheat_code.tscn"
		get_tree().change_scene_to_file(last_scene)
		return
	var level_path = curr_path + "/" + levels.get(curr_level_index)
	get_tree().change_scene_to_file(level_path)
