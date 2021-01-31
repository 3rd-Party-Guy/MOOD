extends Area

signal buttonThree

func onInteracted(_player):
	$AnimationPlayer.play("buttonThree")
	emit_signal("buttonThree")
