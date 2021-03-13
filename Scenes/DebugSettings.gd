extends Control

onready var buttonResume = $MarginContainer/CenterContainer/HBoxContainer/VBoxContainer/Resume
onready var audio = $AudioStreamPlayer

var battleMusic = load("res://Sounds/Music/Battle Theme - alt Mix.wav")


#func play_music():
#	audio.stream = battleMusic
#	audio.play()
#	audio.volume_db = tweaker.musicVolume
	
func _ready():
	buttonResume.grab_focus()
	#play_music()

func _physics_process(_delta):
	if buttonResume.is_hovered():
		buttonResume.grab_focus()
		
func _input(event):
	if event.is_action_pressed("help"):
		get_tree().paused = not get_tree().paused
		visible = not visible
		
		print(Input.get_mouse_mode())
		
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Resume_pressed():
	get_tree().paused = false
	visible = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Restart_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Quit_pressed():
	get_tree().quit()


func _on_speedSlider_value_changed(value):
	tweaker.playerSpeed = value

func _on_musicSlider_value_changed(value):
	tweaker.musicVolume = value
	audio.volume_db = value
	#audio.set_bus_volume_db(audio.get_bus_index("Music"), linear2db(value))

func _on_shotgunRange_value_changed(value):
	tweaker.sgunRange = value
