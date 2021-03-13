extends Area

onready var weapon = preload("res://Scenes/MegaPistol.tscn")
onready var weaponInstance = weapon.instance()

func _on_WeaponPickup_body_entered(body):
	if body.is_in_group("Player"):
		body.Flash("Q & E")
		body.get_node("Head/Camera/Hand").add_child(weaponInstance)
		body.curWeapon = 4
		body.ChangeWeapon(4)
		
		#body.get_node("Head/Camera/Weapon").transform.origin.x = 0.3
		#body.get_node("Head/Camera/Weapon").transform.origin.y = -0.9
		#body.get_node("Head/Camera/Weapon").transform.origin.z = -0.3
		#NOTE: just change the default transform of the weapon
		
		queue_free()
