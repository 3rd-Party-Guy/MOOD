extends Node

onready var audio = $AudioStreamPlayer
var battleMusic = load("res://Sounds/Music/Battle Theme - alt Mix.wav")

func _ready():
	play_music()

func play_music():
	audio.stream = battleMusic
	audio.play()
	
	# temporary music mute whilst testing 
	#audio.volume_db = -80
