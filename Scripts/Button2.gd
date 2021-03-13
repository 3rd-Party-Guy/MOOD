extends Area

signal buttonTwo

func onInteracted(_player):
	$AnimationPlayer.play("buttonTwo")
	emit_signal("buttonTwo")
