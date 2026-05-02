extends Node2D

@export var letter : String = "+"
@onready var key_letter: Label = $KeyLetter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_letter.text = letter
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
