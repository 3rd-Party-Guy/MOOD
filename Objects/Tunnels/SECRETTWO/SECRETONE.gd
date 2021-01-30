extends Spatial


func onInteracted(player):
	player.Flash("SECRET FOUND")
	
	queue_free()
