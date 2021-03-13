extends RigidBody

var MIN_POINTS = 4350
var MAX_POINTS = 6500

var shoot = false

const DAMAGE = 25
const SPEED = 2.5

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.onDamage(DAMAGE)
		# decrease score upon being hit?
		#$"../../../../Score".ChangeScore(rand_range(-MIN_POINTS, -MAX_POINTS))
		queue_free()
	elif body.is_in_group("Secret"):
		body.onDiscovered()
	elif not body.is_in_group("Enemy"):
		queue_free()
