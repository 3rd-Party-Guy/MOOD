extends Area

signal buttonOne

func onInteracted(_player):
	emit_signal("buttonOne")
	
	$AnimationPlayer.play("buttonOne")
