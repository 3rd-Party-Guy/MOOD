extends Area

export var damage = 15

var active = false
var activateable = true
var player

onready var stayTimeTimer = $StayTime
onready var cooldownTimer = $Cooldown
onready var animator = $AnimationPlayer

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		
		if active == false and activateable == true:
			stayTimeTimer.start()
			
		elif active == true: 
			player.onDamage(damage)


func _on_Cooldown_timeout():
	activateable = true
	active = false
	
	
	animator.play_backwards("TrapSpikes")


func _on_StayTime_timeout():
	animator.play("TrapSpikes")
	
	if overlaps_body(player):
		player.onDamage(damage)
		
	active = true
	activateable = false
	
	cooldownTimer.start()


func _on_Area_body_exited(body):
	if body.is_in_group("Player") and active == false:
		stayTimeTimer.stop()
