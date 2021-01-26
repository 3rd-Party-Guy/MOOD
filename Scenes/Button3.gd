extends Area

signal buttonThree

func onInteracted(_player):
	emit_signal("buttonThree")
