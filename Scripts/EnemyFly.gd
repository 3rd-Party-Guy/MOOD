extends KinematicBody2D

onready var sight = $Area/CollisionShape
onready var shootTimer = $ShootTimer

export var speed = 2;
export var minDist = 5;

var velocity = Vector3.ZERO

var player

enum {
	IDLE,
	ALERT,
	COMBAT,
	DEAD
}

var state = IDLE

func _process(_delta):
	match state:
		IDLE:
			velocity = 0
			
		ALERT:
			velocity = global_transform.origin.direction_to(player.global_transform.origin)
			look_at(player.global_transform.origin)
			
		COMBAT:
			pass
			
		DEAD:
			pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if velocity > minDist:
# warning-ignore:return_value_discarded
		move_and_collide(velocity * speed)
		
func _on_ShootTimer_timeout():
	pass # Replace with function body.

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_SightArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		state = ALERT
		if (!player): player = body

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_SightArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		state = IDLE

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_CombatArea_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		state = COMBAT

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_CombatArea_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		state = IDLE
