extends Node2D
@onready var token_3: Sprite2D = $token3
@onready var token_2: Sprite2D = $token2
@onready var token_1: Sprite2D = $token1 #token1 is the lowest and frontmost
@onready var tokens : Array[Sprite2D] = [token_1, token_2, token_3]

"""
Handles visuals for the Blood Container

Pressing the Cycle key places the front-most token to the back.

"""

@export var cycleSeconds : float = 0.5
var cycleTime : float
@export var moveRightOffset : float = 50 # Amount of distance the token will move to the right for cycling
var doCycle : bool = false

var topMostToken : Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateBloodTokenSprites()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("blood_cycle"):
		PerformCycleAnimation()
		topMostToken = readBloodChamber("lastToken")
		if topMostToken != token_2 || topMostToken != token_3: 
			# Do nothing, since cycling only occurs with 2 or 3 tokens (3 is max)
			return
		doCycle = true
		cycleTime = cycleSeconds

	if doCycle == true:
		PerformCycleAnimation()
	else:
		return

func PerformCycleAnimation():
	UpdateBloodTokenSprites()
	pass

func UpdateBloodTokenSprites():
	var empty : Rect2 = Rect2(0,0,0,0)
	var human : Rect2 = Rect2(128, 0, 128, 128)
	var frog : Rect2 = Rect2(0, 0, 128, 128)
	
	var currentChamber = GlobalData.blood_chamber.size()
	
	if (currentChamber == 0) :
		tokens[0].set_region_rect(human)
		tokens[1].set_region_rect(empty)
		tokens[2].set_region_rect(empty)
		return
	
	for i in 3:
		if (currentChamber >= 1):
			if GlobalData.blood_chamber[i] == GlobalData.Animals.FROG:
				tokens[i].set_region_rect(frog)
			currentChamber = currentChamber - 1
		elif (currentChamber == 0):
			tokens[i].set_region_rect(empty)
	
	"""
	if GlobalData.blood_chamber.size() == 0:
		tokens[0].set_region_rect(human)
		tokens[1].set_region_rect(empty)
		tokens[2].set_region_rect(empty)
		# I believe we are handling blood tracking by adding/removing
		# parts of the blood_chamber array.
		# So, an empty blood chamber will have an Array size of 0
		return
	for i in GlobalData.blood_chamber.size():
		if GlobalData.blood_chamber[i] == GlobalData.Animals.FROG:
			tokens[i].set_region_rect(frog)
		else: 
			tokens[i].set_region_rect(empty)
			
			"""
	return

# Reads Alucard's blood charges, and returns something based on parameter
# Blood is held in global_data.gd as an array called blood_chamber
# Adding onto the array uses push_front, saving an enum of the animal into the index
func readBloodChamber(function: String):
	if (function == "lastToken"):
		var chamberSize : int = GlobalData.blood_chamber.size()
		if chamberSize > 3:
			print("blood_container.gd: readBloodChamber() lastToken is beyond 3")
			return token_3
		if chamberSize <= 0:
			print("blood_container.gd: readBloodChamber() lastToken is 0 or less")
			return null
		if chamberSize == 1:
			return token_1
		if chamberSize == 2:
			return token_2
		if chamberSize == 3:
			return token_3
		
	else:
		print("blood_container.gd: readBloodChamber() invalid parameter?")
