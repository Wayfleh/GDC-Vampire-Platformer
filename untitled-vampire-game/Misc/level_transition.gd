extends CanvasLayer

@onready var transition: ColorRect = $Transition
@onready var transition_player: AnimationPlayer = $TransitionPlayer

func transitionOut():
	transition_player.play("transition_out")

func transitionIn():
	transition_player.play("transition_in")
