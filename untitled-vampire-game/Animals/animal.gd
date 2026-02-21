class_name Animal extends Area2D

@export var type: GlobalData.Animals

func _ready():
	add_to_group("animals")
