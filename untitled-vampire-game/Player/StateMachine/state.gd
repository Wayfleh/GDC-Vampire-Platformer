@icon("res://Art/Custom Icons/jump-to-white.svg")
## HEY as a convention, make sure the name of the state nodes are in ALL CAPS (e.g. 'IDLE' not 'Idle')
class_name State extends Node

var machine: StateMachine
var player: Player #as in grandparent
signal transitionToState(next: String) #tell state machine to switch to the next state based on name
## Make sure that the states NEVER interact with each other, and ONLY communicate with the state machine
## I've broken many a CharacterController this way

func _ready() -> void:
	var statemachine = get_parent() #states will never not be a child of statemachines
	await statemachine.ready
	if statemachine is StateMachine:
		machine = statemachine
		player = machine.player

func enter_state():
	pass
func update(delta: float):
	pass
func exit_state():
	pass
