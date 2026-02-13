## VAMPIRE
extends State
"""
Bite-Dash function in vampire form
On-press, Alucard should:
	Begin Bite Dash out of anything (Idle, Walk, Jump -> Bite Dash)
		Note: We want to keep flow of states between states themselves, so have Bite Dash link out of the three other states.
	Lunge, travelling in biteDashDirection, attempting to bite something
		On beginning BiteDash, set all velocity to zero, and during BiteDash, do not apply gravity
			(Still allows other acceleration if applied to Alucard from other sources)
		If he hits an animal, add that animal's charge to the blood thing. Overwrite current charge if applicable.
			(Probably separate Blood Charge Tracker script)
		If he hits a wall, end Bite Dash immediately? (or after an even shorter delay?)
		After travelling for a short amount of time, simply exit the Bite Dash state, causing Alucard to fall to the ground.
	The player does not regain control of Alucard until Bite Dash ends.
		
"""

@export var humanBiteDashTravelDuration = 1.5 #Defines maximum time a bite dash lasts for
@export var humanBiteDashSpeed = 5.0 # Defines speed of horizontal movement during a Human Bite Dash
@export var humanBiteDashResidualSpeed = 50.0 # When bite dash ends, retain a little momentum
var humanBiteDashTravelTime: float
var dashingDirection: Vector2

#TODO add animations for BiteDash (Anticipiation, Travel, Follow-through) state
func enter_state():
	dashingDirection = player.biteDashDirection
	humanBiteDashTravelTime = 0.0
	player.velocity = Vector2(0,0) ## Beginning the human form bite dash cancels current momentum
	print("Human BiteDash Start!")
	print("dashing direction: " + str(dashingDirection))
func update(delta: float):
	player.velocity = dashingDirection * humanBiteDashSpeed
	print(player.velocity)
	
	humanBiteDashTravelTime = humanBiteDashTravelTime + delta
	if (humanBiteDashTravelTime >= humanBiteDashTravelDuration):
		transitionToState.emit("V_IDLE")

func exit_state():
	player.velocity = dashingDirection * humanBiteDashResidualSpeed
	pass
