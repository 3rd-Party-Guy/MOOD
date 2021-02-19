extends Control

var scene = "res://Scenes/Root.tscn"
var testScene = "res://Scenes/TestScene.tscn"

func _ready():
	$RichTextLabel/AnimationPlayer.play("Start")

func _input(event):
	if event is InputEventKey and event.pressed:
		print("PLAYER STARTED GAME")
		Start()

func Start():
	get_tree().change_scene(scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
