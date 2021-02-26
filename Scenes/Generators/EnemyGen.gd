extends Spatial

export var distance = 5

onready var enemies = [preload("res://Scenes/Enemy.tscn"), preload("res://Scenes/EnemyMelee.tscn"), preload("res://Scenes/EnemyProjectile.tscn")]

func _on_Timer_timeout():
	var enemyInstance = enemies[rand_range(0, 3)].instance()
	$"../".add_child(enemyInstance)
	
	enemyInstance.global_transform.origin.x = global_transform.origin.x + rand_range(-distance, distance)
	enemyInstance.global_transform.origin.z = global_transform.origin.z + rand_range(-distance, distance)
