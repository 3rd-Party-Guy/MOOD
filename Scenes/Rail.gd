extends Area

func _on_DeathTimer_timeout():
	queue_free()
