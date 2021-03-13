extends Control

onready var buttonEndless = $MarginContainer/CenterContainer/VBoxContainer/Endless
onready var buttonResume = $MarginContainer/CenterContainer/VBoxContainer/Resume
onready var buttonRestart = $MarginContainer/CenterContainer/VBoxContainer/Restart
onready var buttonQuit = $MarginContainer/CenterContainer/VBoxContainer/Quit

var endlessScene = "res://Scenes/Endless.tscn"

func _ready():
	buttonResume.grab_focus()

func _physics_process(_delta):
	if buttonEndless.is_hovered():
		buttonEndless.grab_focus()
	if buttonResume.is_hovered():
		buttonResume.grab_focus()
	if buttonRestart.is_hovered():
		buttonRestart.grab_focus()
	if buttonQuit.is_hovered():
		buttonQuit.grab_focus()
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
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

func _on_Restart_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Endless_pressed():
	get_tree().paused = false
	get_tree().change_scene(endlessScene)
