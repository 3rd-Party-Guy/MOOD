extends Spatial

onready var sec = $"SECRETTWO"

func onInteracted(player):
	player.Flash("SECRET FOUND")
	
	sec.queue_free()
	queue_free()
