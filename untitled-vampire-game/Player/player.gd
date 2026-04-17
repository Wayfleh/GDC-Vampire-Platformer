class_name Player
extends CharacterBody2D

#TODO remember that you commented out the UpdateUI() function

#change speed, jump height, and gravity
@export var speed: float = 500.0
@export var jump_impulse: float = 500.0
@export var gravity: float = 200.0
@export var friction: float = 10.0

@export var bite_dash_direction: Vector2
var previous_position: Vector2 #Velocity value in previous frame. Used for calculating Bite Dash Direction


var direction : int #either forward (1) or backward (-1)
#---------- For Bite Dash ----------#
var previous_direction : int = 1
var bite_dash_used: bool = false
@onready var bite_hitbox := $CurrentDirection/BiteHitbox
@onready var tongue : Tongue = %Tongue #sahur
@onready var rat_hole_interactor : Area2D = $RatHoleInteractor

@onready var state_machine := $TransformationSM
@onready var collider := $Collider
@onready var anim_sprite : AnimatedSprite2D = %AlucardSprite


#---------- Particles ----------#
@onready var blood_particles := $BloodParticles
@onready var afterimage_particles := $AfterimageParticles
@onready var left_afterimage : Texture2D = preload("res://Art/Placeholder/anim_bitedash_outline_afterimage_LEFT.png")
@onready var right_afterimage : Texture2D = preload("res://Art/Placeholder/anim_bitedash_outline_afterimage_RIGHT.png")


#---------- RayCasts ----------#
@onready var frog_floor_check : RayCast2D = $FrogFloorCheck

#---------- Sounds ----------#
@onready var footstep_player: AudioStreamPlayer2D = $FootstepPlayer
@export var footstep_1: AudioStream
@export var footstep_2: AudioStream
@export var footstep_interval: float = 0.35
@onready var jump_sound_player: AudioStreamPlayer2D = $JumpSound
@export var jump_sound: AudioStream
@onready var sound_v_animal_bitten: AudioStreamPlayer2D = $SoundV_AnimalBitten

var footstep_index: int = 0
var footstep_timer: float = 0.0

#---------- UI Connections ----------#
@onready var bloodContainer = %UI/BloodContainer

var just_bit_animal := false

var blood_cache : Array[int] = []


signal detransform

func _ready() -> void:
	bite_dash_direction = Vector2(1,0)
	previous_position = Vector2(0,0)
	bite_hitbox.area_entered.connect(bite_animal)
	


func _physics_process(delta: float) -> void:
	
	
	if direction == -1:
		afterimage_particles.texture = left_afterimage
	if direction == 1:
		afterimage_particles.texture = right_afterimage
	
	move_and_slide() # Applies velocity to the in-game object
	#bite_dash_direction = DetermineBiteDashDirection(position, previous_position, bite_dash_direction)
	#previous_position = position
					# move_and_slide() is a CharacterBody2D Function
	if is_walking_on_floor():
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			play_next_footstep()
			footstep_timer = footstep_interval
	else:
		stop_footsteps()

func is_walking_on_floor() -> bool:
	return is_on_floor() and direction != 0 and abs(velocity.x) > 5

func play_next_footstep() -> void:
	if footstep_1 == null or footstep_2 == null:
		return
	
	if footstep_index == 0:
		footstep_player.stream = footstep_1
		footstep_index = 1
	else:
		footstep_player.stream = footstep_2
		footstep_index = 0
	
	footstep_player.play()

func stop_footsteps() -> void:
	footstep_timer = 0.0
	footstep_player.stop()

func play_jump_sound() -> void:
	if jump_sound == null:
		return
	
	jump_sound_player.stream = jump_sound
	jump_sound_player.play()

func apply_gravity(delta: float, multiplier: float = 1.0) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta * multiplier

func apply_horizontal_movement(delta: float):
	if direction == 0.0:
		velocity.x = lerpf(velocity.x, 0.0, delta * friction)
	else:
		velocity.x = speed * 100 * direction * delta

func apply_friction(delta: float, friction_mult : int):
	if (-0.005 <= velocity.x && velocity.x <= 0.005): #Clamping velocity as it approaches 0 to prevent too many lerpf calls.
		velocity.x = 0
	else:
		velocity.x = lerpf(velocity.x, 0.0, delta * friction_mult)

func apply_input_direction(delta: float):
	direction = Input.get_axis("left", "right")
	if direction != 0:
		$CurrentDirection.scale.x = direction
		previous_direction = direction

func bite_animal(area: Area2D):
	if area is Animal:
		just_bit_animal = true
		sound_v_animal_bitten.play()
		blood_particles.restart()
		GlobalData.blood_collected(area)
		area.queue_free()
		GlobalData.animal_bitten()
		UpdateUI()
		

# Using player velocity to determine Bite Dash facing direction
# DetermineBiteDashDirection() takes bite_dash_direction as an argument, so it can 
#		pass itself (and remain the same) if there is no change in position
func DetermineBiteDashDirection(currPos: Vector2, prevPos: Vector2, bite_dash_direction: Vector2):
	if (currPos == null || prevPos == null):
		print("Player.gd: DetermineBiteDashDirection() - current or previous position is null?")
		print(currPos)
		print(prevPos)
		return Vector2(1,0)
	if (currPos == prevPos):
		return bite_dash_direction
	var dir = (currPos - prevPos).normalized()
	# print(dir)wd
	return dir

func TransformToVampire():
	detransform.emit()


func UpdateUI():
	#bloodContainer.UpdateBloodTokenSprites()
	pass

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		GlobalData.blood_chamber.clear()
		UpdateUI()
		get_tree().reload_current_scene()
		return
	
	if Input.is_action_just_pressed("blood_cycle"):
		GlobalData.blood_cycle()
		return
		
	if Input.is_action_just_pressed("transform") && state_machine.current_state != state_machine.states["VAMPIRE"]:
		TransformToVampire()
