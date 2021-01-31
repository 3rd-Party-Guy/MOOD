extends Spatial

onready var sec = $"SECRETTWO"
onready var ceiling = $"../SecretCeiling"

func onInteracted(player):
	player.Flash("SECRET FOUND")
	
	sec.queue_free()
	ceiling.queue_free()
	queue_free()
