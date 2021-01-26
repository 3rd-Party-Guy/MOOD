extends Area

export var health = 25

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.health != body.maxHealth:
			body.onHeal(health)
			
			queue_free()
