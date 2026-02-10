class_name StateMachine 
extends Node

var current_state: State
@export var parent: CharacterBody2D
var states: Dictionary = {}
@export var initial_state: State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(change_state)
	if initial_state:
		current_state = initial_state
		initial_state.enter_state()

func _process(delta):
	if current_state:
		current_state.update(delta)

func change_state(next: String):
	#this is assuming the name is in the dictionary, which it should be
	var next_state: State = states[next]
	current_state.exit_state()
	next_state.enter_state()
	current_state = next_state
	print(next)
