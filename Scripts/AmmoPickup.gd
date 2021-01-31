extends Area

export var weapon = 0 #0: rifle; 1: shotgun; 2: launcher
export var ammo = 15

func _on_AmmoPickup_body_entered(body):
	if body.is_in_group("Player"):
		print("AMMO COLLIDED WITH PLAYER")
		print(str(weapon))
		match weapon:
			0:
				var rifle = body.get_node("Head/Camera/Hand/Rifle")
				
				if rifle != null:
					rifle.onAddAmmo(ammo)
					queue_free()
			1:
				var shotgun = body.get_node("Head/Camera/Hand/Shotgun")
				
				if shotgun != null:
					shotgun.onAddAmmo(ammo)
					queue_free()
			2:
				var launcher = body.get_node("Head/Camera/Hand/RocketLauncher")
				
				if launcher != null:
					launcher.onAddAmmo(ammo)
					queue_free()
