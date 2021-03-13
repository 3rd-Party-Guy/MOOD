extends KinematicBody

onready var shootTimer = $ShootTimer

export var speed = 2;
export var minDist = 5;

var velocity : Vector3

onready var player = get_parent().get_parent().get_node("Player")

var distance : float

enum {
	IDLE,
	ALERT,
	COMBAT,
	DEAD
}

var state = IDLE

func _process(_delta):
	distance = global_transform.origin.distance_to(player.global_transform.origin)
	
	print("DISTANCE: " + str(distance))
	
	if distance >= 30:
		state = IDLE
	elif distance >= 25:
		state = ALERT
	elif distance >= 10:
		state = COMBAT
	
	match state:
		IDLE:
			velocity = Vector3.ZERO
			
		ALERT:
			velocity = global_transform.origin.direction_to(player.global_transform.origin)
			look_at(player.global_transform.origin, Vector3.UP)
			
		COMBAT:
			velocity = global_transform.origin.direction_to(player.global_transform.origin)
			look_at(player.global_transform.origin, Vector3.UP)
			
		DEAD:
			pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if distance > minDist:
		# warning-ignore:return_value_discarded
		move_and_collide((velocity * speed) * delta)
		
func _on_ShootTimer_timeout():
	pass # Replace with function body.
