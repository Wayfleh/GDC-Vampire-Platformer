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
	
	Beginning the bite-dash will have a short moment where Alucard falls slightly, in "anticipation" of dashing.
		
"""

@export var humanBiteDashTravelDuration = 1.5 # Defines maximum time a bite dash lasts for
@export var humanBiteDashSpeed = 5.0 # Defines speed of horizontal movement during a Human Bite Dash
@export var humanBiteDashResidualSpeed = 50.0 # When bite dash ends, retain a flat amount of small momentum
@export var humanBiteDashAnticipationDuration = 0.2 #Defines how long Alucard will hang in the air before starting dash (for game feel)
@export var humanBiteDashAnticipationGravityFactor = 0.2 # Alucard gets a tiny bit of gravity during anticipation of bite dash.
var humanBiteDashAnticipationTime: float
var humanBiteDashTravelTime: float
var dashingDirection: Vector2
var humanDashingState: String
	#Use the following strings to handle dashing logic:
	# "anticipate"		anticipation frames pre-dash
	# "dashing"			movement portion of dash, the act of dash
	# "followthrough"	followthrough frames post-dash. NOTE: Does this even go in this script?
	# "exit"			Signals update() to exit this state back into V_IDLE


#TODO add animations for BiteDash (Anticipiation, Travel, Follow-through) state
func enter_state():
	dashingDirection = player.biteDashDirection
	humanBiteDashTravelTime = 0.0
	humanBiteDashAnticipationTime = 0.0
	player.velocity = Vector2(0,0) ## Beginning the human form bite dash cancels current momentum
	humanDashingState = "anticipate"
	# print("Human BiteDash Start!")
	# print("dashing direction: " + str(dashingDirection))
func update(delta: float):
	if (humanDashingState == "anticipate"):
		AnticipateDash(delta)
	elif (humanDashingState == "dashing"):
		DoDash(delta)
	elif (humanDashingState == "exit"):
		transitionToState.emit("V_IDLE")
	else: 
		print("v_bitedash.gd, update(): Code shouldn't reach here -- Neither AnticipateDash or DoDash?")
		return
	

func exit_state():
	player.velocity = dashingDirection * humanBiteDashResidualSpeed
	pass

func DoDash(delta: float):
	player.velocity = dashingDirection * humanBiteDashSpeed
	# print(player.velocity)
	
	humanBiteDashTravelTime = humanBiteDashTravelTime + delta
	if (humanBiteDashTravelTime >= humanBiteDashTravelDuration):
		humanDashingState = "exit"
	return

func AnticipateDash(delta: float):
	player.apply_gravity(delta, humanBiteDashAnticipationGravityFactor)
	
	humanBiteDashAnticipationTime = humanBiteDashAnticipationTime + delta
	if (humanBiteDashAnticipationTime >= humanBiteDashAnticipationDuration):
		humanDashingState = "dashing"
	return
