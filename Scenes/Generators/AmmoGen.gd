extends Spatial

export var distance = 5

onready var ammo = preload("res://Scenes/AmmoPickup.tscn")

func _on_Timer_timeout():
	var ammoInstance = ammo.instance()
	$"../".add_child(ammoInstance)
	
	ammoInstance.global_transform.origin.x = global_transform.origin.x + rand_range(-distance, distance)
	ammoInstance.global_transform.origin.y = global_transform.origin.y
	ammoInstance.global_transform.origin.z = global_transform.origin.z + rand_range(-distance, distance)
	
	var weapon = rand_range(0, 100)
	if weapon < 50:
		ammoInstance.weapon = 0
	elif weapon < 90:
		ammoInstance.weapon = 1
	elif weapon > 90:
		ammoInstance.weapon = 2
