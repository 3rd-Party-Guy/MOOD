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
var velocity

export var sightRange = 20
export var minDistance = 1.5

export var speed = 10

onready var raycast = $RayCast
onready var eyes =  $Eyes
onready var hitTimer = $HitTimer
onready var navigationTimer = $NavigationTimer
onready var audio = $Audio
onready var anim = $ratManV2/AnimationPlayer

onready var bloodKicked = preload("res://Scenes/BloodSplatterKick.tscn")

onready var navigation = get_parent().get_parent()

onready var player = get_parent().get_parent().get_node("Player")

var path = []
var pathNode = 0

func _ready():
	$"SightRange/CollisionShape".shape.set_radius(sightRange)

func _physics_process(_delta):
	
	# move towards the player
	if pathNode < path.size() and state == ALERT:
		# only calculate path and move if over minDistance
		if global_transform.origin.distance_to(player.global_transform.origin) > minDistance:
			var direction = (path[pathNode] - global_transform.origin)	# calculates the direction towards the player
			
			if direction.length() < 1:									# if were close to the node, move on to the next one
				pathNode += 1
			else:
	# warning-ignore:return_value_discarded
				move_and_slide(direction.normalized() * speed, Vector3.UP)

func _process(_delta):
	if health <= 0 and not audio.playing:
		print("Enemy has died!")
		audio.play()
		state = DEAD
	
	match state:
		IDLE:
			if not anim.current_animation == "idleBat":
				anim.play("idleBat")
			pass
		
		ALERT:
			# look at player
			if target:
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
			if not anim.current_animation == "walkBat":
				anim.play("walkBat")
			pass
		KICKED:
			var collide = move_and_collide(velocity * 100)
			if collide:
				var b = bloodKicked.instance()
				add_child(b)
				b.get_node("Particles").emitting = true
				health -= 30
			pass
		BERSERK:
			if not anim.current_animation == "batSwing":
				anim.play("batSwing")
			pass
		

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	pathNode = 0

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player") and state != KICKED and state != BERSERK:
		state = ALERT
		target = body
		navigationTimer.start()


func _on_SightRange_body_exited(body):
	if body.is_in_group("Player") and state != KICKED:
		state = IDLE

func _on_NavigationTimer_timeout():
	move_to(player.global_transform.origin)


func _on_Audio_finished():
	queue_free()

func _on_HitTimer_timeout():
	player.onDamage(damage)


func _on_HitRange_body_entered(body):
	if body.is_in_group("Player"):
		state = BERSERK
		hitTimer.start()


func _on_HitRange_body_exited(body):
	if body.is_in_group("Player"):
		state = ALERT
		hitTimer.stop()

func onKicked(pos):
	velocity = -pos
	state = KICKED
