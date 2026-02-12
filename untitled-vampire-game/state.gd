@abstract
## HEY as a convention, make sure the name of the state nodes are in ALL CAPS (e.g. 'IDLE' not 'Idle')
class_name State extends Node

var machine: StateMachine
var gp: CharacterBody2D #as in grandparent
signal transitionToState(next: String) #tell state machine to switch to the next state based on name
## Make sure that the states NEVER interact with each other, and ONLY communicate with the state machine
## I've broken many a CharacterController this way

func _ready() -> void:
	var statemachine = get_parent() #states will never not be a child of statemachines
	if statemachine is StateMachine:
		machine = statemachine
		gp = statemachine.parent

@abstract func enter_state()
@abstract func update(delta: float)
@abstract func exit_state()
