extends Spatial

onready var sec = $"SECRETONE"

func onInteracted(player):
	player.Flash("SECRET FOUND")
	
	sec.queue_free()
	queue_free()
