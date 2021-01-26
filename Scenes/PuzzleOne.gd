extends CollisionShape

var one = false
var two = false
var three = false

onready var buttonOne = $Button
onready var buttonTwo = $Button2
onready var buttonThree = $Button3

func _ready():
# warning-ignore:return_value_discarded
	buttonOne.connect("buttonOne", self, "onOne")
# warning-ignore:return_value_discarded
	buttonTwo.connect("buttonTwo", self, "onTwo")
# warning-ignore:return_value_discarded
	buttonThree.connect("buttonThree", self, "onThree")

func onOne():
	one = true
	print("ONE ACTIVATED")
	if one and two and three:
		queue_free()

func onTwo():
	two = true
	print("ONE ACTIVATED")
	if one and two and three:
		queue_free()

func onThree():
	three = true
	print("ONE ACTIVATED")
	if one and two and three:
		queue_free()
