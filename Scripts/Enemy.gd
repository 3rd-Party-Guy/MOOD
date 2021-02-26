extends KinematicBody

const TURN_SPEED = 10

enum {
	IDLE,
	ALERT,
	BERSERK,
	DEAD,
	KICKED
}

var state = IDLE

export var health = 30
export var damage = 5
var target

export var speed = 10
export var sightRange : int
export var minDistance : int 
var velocity

export var move = true

onready var raycast = $RayCast
onready var eyes =  $Eyes
onready var shootTimer = $ShootTimer
onready var navigationTimer = $NavigationTimer
onready var audio = $Audio
onready var audioAlert = $AudioAlert
onready var anim = $rifleRatManV18/AnimationPlayer

onready var navigation = get_parent().get_parent()

onready var player = get_parent().get_parent().get_node("Player")

onready var bloodKicked = preload("res://Scenes/BloodSplatterKick.tscn")

var path = []
var pathNode = 0

func _ready():
	$"SightRange/CollisionShape".shape.set_radius(sightRange)

func _physics_process(_delta):
	
	# move towards the player
	if pathNode < path.size() and move:
		# only calculate and move if the enemy is at a long enough distance
		if global_transform.origin.distance_to(player.global_transform.origin) > minDistance:
			var direction = (path[pathNode] - global_transform.origin)	# calculates the direction towards the player
			
			if direction.length() < 1:									# if were close to the node, move on to the next one
				pathNode += 1
			else:
	# warning-ignore:return_value_discarded
				move_and_slide(direction.normalized() * speed, Vector3.UP)

func _process(_delta):
	if health <= 0 and not audio.playing:
		state = DEAD
	
	match state:
		DEAD:
			print("Enemy has died!")
			anim.play("death")
			audio.play()
			if anim.current_animation_position > 0.6:
				queue_free()
		IDLE:
			if not anim.current_animation == "idle":
				anim.play("idle")
			pass
		
		ALERT:
			# look at player
			look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
			rotate_z(deg2rad(eyes.rotation.z * TURN_SPEED))
			if not anim.current_animation == "walkAndShoot":
				anim.play("walkAndShoot")
			pass
		KICKED:
			var collide = move_and_collide(velocity * 5000)
			if collide:
				var b = bloodKicked.instance()
				add_child(b)
				b.get_node("Particles").emitting = true
				health -= 30
		BERSERK:
			look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
			rotate_z(deg2rad(eyes.rotation.z * TURN_SPEED))
			if not anim.current_animation == "walkAndShoot":
				anim.play("walkAndShoot")
			pass
		

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	pathNode = 0

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player") and state != KICKED:
		if state != DEAD:
			state = ALERT
			audioAlert.play()
			target = body
			shootTimer.start()
			navigationTimer.start()


func _on_SightRange_body_exited(body):
	if body.is_in_group("Player") and state != KICKED:
		shootTimer.stop()
		if state != DEAD:
			state = IDLE


func _on_ShootTimer_timeout():
	if state != DEAD:
		if raycast.is_colliding():
			var hit = raycast.get_collider()
			if hit.is_in_group("Player"):
				state = BERSERK
				print("Player got hit.")
				hit.onDamage(damage)


func _on_NavigationTimer_timeout():
	if state != DEAD:
		move_to(player.global_transform.origin)


#func _on_Audio_finished():
#	queue_free()''''

func onKicked(pos):
	velocity = -pos
	state = KICKED
