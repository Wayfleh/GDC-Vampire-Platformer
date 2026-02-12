@icon("res://Art/Custom Icons/todo-white.svg")
class_name StateMachine 
extends Node

var current_state: State
@export var player: Player
var states: Dictionary = {}
@export var initial_state: State
@export var is_initial_machine: bool = false 

func _ready() -> void:
	await player.ready
	set_process(is_initial_machine) #machine is not processed (state is not updated) if this is not the initial machine
	for state in get_children(): #children of the statemachine should only be the states themselves
		if state is State:
			states[state.name] = state
			state.transitionToState.connect(change_state)
	if initial_state:
		begin_state_machine(initial_state)


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

#sets the start state and enters it
#can be used to start a statemachine in a state other than initial_state
# (e.g. walking while transforming starts you in walking state)
func begin_state_machine(starting_state: State):
	current_state = starting_state
	starting_state.enter_state()
