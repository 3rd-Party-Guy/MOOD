extends KinematicBody

var health = 100

onready var shootTimer = $ShootTimer
onready var projectile = preload("res://Scenes/EnemyProjectileBullet.tscn")
onready var shootPos = $ShootPos

export var speed = 2
export var orbitSpeed = 5
export var minDist = 5

var velocity : Vector3

onready var player = get_parent().get_parent().get_node("Player")

var distance : float
var offset = 0
var rotation_duration = 5
var radius = 15

enum {
	IDLE,
	ALERT,
	COMBAT,
	DEAD
}

var state = IDLE

func _process(delta):
	if health <= 0:
		OnDeath()
		
	distance = global_transform.origin.distance_to(player.global_transform.origin)
	
	print("DISTANCE: " + str(distance))
	
	if distance >= 30:
		state = IDLE
	elif distance <= 30 and distance > 10:
		state = ALERT
	elif distance <= 10:
		state = COMBAT
	
	match state:
		IDLE:
			shootTimer.stop()
			velocity = Vector3.ZERO
			
		ALERT:
			if shootTimer.is_stopped():
				shootTimer.start(0)
				
			velocity = global_transform.origin.direction_to(player.global_transform.origin)
			look_at(player.global_transform.origin, Vector3.UP)
			
		COMBAT:
			velocity = transform.basis.x * orbitSpeed
			look_at(player.transform.origin, Vector3.UP)
			
		DEAD:
			pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if distance > minDist:
		# warning-ignore:return_value_discarded
		move_and_collide((velocity * speed) * delta)
		
func _on_ShootTimer_timeout():
	if state != DEAD:
			var p = projectile.instance()
			shootPos.add_child(p)
			p.shoot = true

func OnDeath():
	queue_free()
