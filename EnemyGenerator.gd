extends Spatial

export var distance = 5

onready var enemies = [preload("res://Scenes/Enemy.tscn"), preload("res://Scenes/EnemyMelee.tscn"), preload("res://Scenes/EnemyProjectile.tscn")]

func _on_Timer_timeout():
	var enemyInstance = enemies[rand_range(0, 3)].instance()
	$"../".add_child(enemyInstance)
	
	enemyInstance.global_transform.origin = Vector3(rand_range(-distance, distance), 1, rand_range(-distance, distance))
