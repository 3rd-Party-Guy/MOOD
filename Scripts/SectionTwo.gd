extends StaticBody

# conditions to win:
# 
# kill at least 10 enemies 

onready var colBegin = $CollisionBegin
onready var colEnd = $CollisionEnd

var enemiesKilled = 0
export var enemiesToKill = 10

var activated = false
var passed = false

var player

var time
var damageTaken = 0

var timePassed = 0
var seconds
var minutes

func _process(delta):
	if passed == false and activated == true:
		timePassed += delta
		
		seconds = fmod(timePassed, 60)
		minutes = fmod(timePassed, 3600) / 60

func _on_Area_body_entered(body):
	if body.is_in_group("Player") and activated == false and passed == false:
		player = body
		player.Flash("KICK W RIGHT MOUSE")
		
		onStart()

func _on_Area_body_exited(body):
	if body.is_in_group("Enemy"):
		enemiesKilled += 1
		
		if enemiesKilled >= enemiesToKill and activated == true and passed == false:
			onFinish()

func onStart():
	colBegin.disabled = false
	colEnd.disabled = false
	print("SECTION ONE BEGINS!")
	
	player.connect("damageTaken", self, "onPlayerDamage")
	
	activated = true

func onFinish():
	queue_free()
	print("SECTION TWO ENDS!")
	
	passed = true
	
	player.find_node("SectionStatsTime").text = "%02d : %02d" % [minutes, seconds]
	player.find_node("SectionStatsAmmo").text = "Damage Taken: " + str(damageTaken)
	player.find_node("UIAnimator").play("SectionStats")
	player.find_node("SectionCompletedAudio").play()

func onPlayerDamage(dmg):
	damageTaken += dmg
