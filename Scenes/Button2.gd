extends Area

signal buttonTwo

func onInteracted(_player):
	emit_signal("buttonTwo")
