extends Spatial

onready var sec = $"SECRETTWO"
onready var flr = $"../ColSecretFloor"

func onInteracted(player):
	player.Flash("SECRET FOUND")
	
	sec.queue_free()
	flr.queue_free()
	queue_free()
