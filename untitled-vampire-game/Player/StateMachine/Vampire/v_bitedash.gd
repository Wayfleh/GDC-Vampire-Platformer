## VAMPIRE
extends State
"""
Bite-Dash function in vampire form
On-press, Alucard should:
	Begin Bite Dash out of anything (Idle, Walk, Jump -> Bite Dash)
		Note: We want to keep flow of states between states themselves, so have Bite Dash link out of the three other states.
	Lunge, travelling in bite_dash_direction, attempting to bite something
		On beginning BiteDash, set all velocity to zero, and during BiteDash, do not apply gravity
			(Still allows other acceleration if applied to Alucard from other sources)
		If he hits an animal, add that animal's charge to the blood thing. Overwrite current charge if applicable.
			(Probably separate Blood Charge Tracker script)
		If he hits a wall, end Bite Dash immediately? (or after an even shorter delay?)
		After travelling for a short amount of time, simply exit the Bite Dash state, causing Alucard to fall to the ground.
	The player does not regain control of Alucard until Bite Dash ends.
	
	Beginning the bite-dash will have a short moment where Alucard falls slightly, in "anticipation" of dashing.
		
"""

@export var h_bite_dash_travel_duration = 0.075 # Defines maximum time a bite dash lasts for
@export var h_bite_dash_speed = 1200.0 # Defines speed of horizontal movement during a Human Bite Dash
@export var h_bite_dash_residual_speed = 200.0 # When bite dash ends, retain a flat amount of small momentum
@export var h_bite_dash_anticipation_duration = 0.2 #Defines how long Alucard will hang in the air before starting dash (for game feel)
@export var h_bite_dash_anticipation_gravity_factor = 0.2 # Alucard gets a tiny bit of gravity during anticipation of bite dash.
var h_bite_dash_anticipation_time: float
var h_bite_dash_travel_time: float
var dashing_direction: Vector2
var h_dashing_state: String

@onready var afterimages : CPUParticles2D
@onready var V_BitedashSFX : AudioStreamPlayer2D = $"../../../../SoundV_BiteDash"

	#Use the following strings to handle dashing logic:
	# "anticipate"		anticipation frames pre-dash
	# "dashing"			movement portion of dash, the act of dash
	# "followthrough"	followthrough frames post-dash. NOTE: Does this even go in this script?
	# "exit"			Signals update() to exit this state back into V_IDLE


#TODO add animations for BiteDash (Anticipiation, Travel, Follow-through) state
func enter_state():
	player.bite_dash_used = true
	dashing_direction = Vector2(player.previous_direction, 0.0) if player.is_on_floor() else Vector2(player.previous_direction,-0.2).normalized()
	h_bite_dash_travel_time = 0.0
	h_bite_dash_anticipation_time = 0.0
	player.velocity = Vector2(0,0) ## Beginning the human form bite dash cancels current momentum
	h_dashing_state = "anticipate"
	
	# print("Human BiteDash Start!")
	# print("dashing direction: " + str(dashing_direction))
func update(delta: float):
	if (h_dashing_state == "anticipate"):
		AnticipateDash(delta)
	elif (h_dashing_state == "dashing"):
		DoDash(delta)
	elif (h_dashing_state == "exit"):
		player.just_bit_animal = false
		transitionToState.emit("V_IDLE")
	else: 
		print("v_bitedash.gd: update() - Code shouldn't reach here -- Neither AnticipateDash or DoDash?")
		return
	

func exit_state():
	player.anim_sprite.play("vampire_idle")
	player.velocity = dashing_direction * h_bite_dash_residual_speed
	player.bite_hitbox.monitoring = false
	

func DoDash(delta: float):
	player.anim_sprite.play("vampire_dash")
	V_BitedashSFX.play()
	player.velocity = dashing_direction * h_bite_dash_speed
	# print(player.velocity)
	
	h_bite_dash_travel_time = h_bite_dash_travel_time + delta
	#end state at end of travel time or if player touches an animal
	if (h_bite_dash_travel_time >= h_bite_dash_travel_duration || player.just_bit_animal): 
		h_dashing_state = "exit"
	return

func AnticipateDash(delta: float):
	player.apply_gravity(delta, h_bite_dash_anticipation_gravity_factor)
	
	h_bite_dash_anticipation_time = h_bite_dash_anticipation_time + delta
	if (h_bite_dash_anticipation_time >= h_bite_dash_anticipation_duration):
		h_dashing_state = "dashing"
		player.bite_hitbox.monitoring = true #only monitor the hitbox during the dash, not before
		player.afterimage_particles.emitting = true #play the afterimages when you dash
	return
