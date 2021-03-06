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

export var sightRange : int = 20
export var minDistance : int = 5

export var speed = 10
var velocity

onready var raycast = $RayCast
onready var eyes =  $Eyes
onready var shootTimer = $ShootTimer
onready var navigationTimer = $NavigationTimer
onready var audio = $Audio
onready var audioAlert = $AudioAlert
onready var anim = $fatRatManV19/AnimationPlayer

onready var projectile = preload("res://Scenes/EnemyProjectileBullet.tscn")
onready var bloodKicked = preload("res://Scenes/BloodSplatterKick.tscn")
onready var ammo = preload("res://Scenes/AmmoPickup.tscn")

onready var navigation = get_parent().get_parent()

onready var player = get_parent().get_parent().get_node("Player")

var path = []
var pathNode = 0

func _ready():
	$"SightRange/CollisionShape".shape.set_radius(sightRange)

func _physics_process(_delta):
	
	# move towards the player
	if pathNode < path.size() and state == ALERT:
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
		#print("Enemy has died!")
		#audio.play()
		state = DEAD
	
	match state:
		DEAD:
			print("Enemy has died!")
			anim.play("death")
			audio.play()
			if anim.current_animation_position > 1.2:
				queue_free()
		IDLE:
			if not anim.current_animation == "idle":
				anim.play("idle")
			pass
		
		ALERT:
			# look at player
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
			if not anim.current_animation == "patrol":
					anim.play("patrol")
			pass
		KICKED:
			var collide = move_and_collide(velocity * 10000)
			if collide:
				var b = bloodKicked.instance()
				add_child(b)
				b.get_node("Particles").emitting = true
				health -= 30
				
			pass
		BERSERK:
			if not anim.current_animation == "fire":
				anim.play("fire")
			pass
		

func move_to(target_pos):
	path = navigation.get_simple_path(global_transform.origin, target_pos)
	pathNode = 0

func _on_SightRange_body_entered(body):
	if body.is_in_group("Player") and not state == KICKED:
		if state != DEAD:
			state = ALERT
			audioAlert.play()
			target = body
			shootTimer.start()
			navigationTimer.start()


func _on_SightRange_body_exited(body):
	if body.is_in_group("Player") and not state == KICKED:
		if state != DEAD:
			state = IDLE


func _on_ShootTimer_timeout():
	if raycast.is_colliding():
		if state != DEAD:
			state = ALERT
			var p = projectile.instance()
			add_child(p)
			p.shoot = true


func _on_NavigationTimer_timeout():
	move_to(player.global_transform.origin)


func _on_Audio_finished():
	var ammoInstance = ammo.instance()
	$"../".add_child(ammoInstance)
	
	var chance = rand_range(0, 100)
	
	ammoInstance.weapon = 2
	
	ammoInstance.global_transform.origin.x = global_transform.origin.x + rand_range(-2, 2)
	ammoInstance.global_transform.origin.y = global_transform.origin.y
	ammoInstance.global_transform.origin.z = global_transform.origin.z + rand_range(-2, 2)
	
	queue_free()

func onKicked(pos):
	velocity = -pos
	state = KICKED
