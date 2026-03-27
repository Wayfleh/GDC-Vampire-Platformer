extends Node2D
@onready var overworld: AudioStreamPlayer2D = $Overworld
@onready var main_menu: AudioStreamPlayer2D = $MainMenu
@onready var currentTrack : String = "overworld"

@onready var musicTracks : Array[AudioStreamPlayer2D] = [overworld, main_menu]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func ChangeTrack(track:String):
	if (currentTrack == track):
		print("music.gd: ChangeTrack() -- Attempting to change to already playing track")
		return
	
	StopAll()
	match track:
		"main_menu":
			main_menu.play()
			currentTrack = "main_menu"
			return
		"overworld":
			overworld.play()
			currentTrack = "overworld"
			return
		_:
			overworld.play()
			print("music.gd: ChangeTrack() -- Invalid string, default to Overworld")
			return
	print("music.gd: ChangeTrack() -- match-case statement did not return?")
	return
	
func StopAll():
	for track in musicTracks:
		track.stop()
