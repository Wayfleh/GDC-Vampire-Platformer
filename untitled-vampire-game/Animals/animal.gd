class_name Animal extends Area2D

@export var type: GlobalData.Animals

func _ready():
	add_to_group("animals")
	print("Animal ready:", name, " group_count=", get_tree().get_nodes_in_group("animals").size())
