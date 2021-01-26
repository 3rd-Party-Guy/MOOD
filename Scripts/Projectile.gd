extends RigidBody

var MIN_POINTS = 4350
var MAX_POINTS = 6500

var shoot = false

const DAMAGE = 65
const SPEED = 5

func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * SPEED)


func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		$"../../../../Score".ChangeScore(rand_range(MIN_POINTS, MAX_POINTS))
		queue_free()
	elif not body.is_in_group("Player"):
		queue_free()