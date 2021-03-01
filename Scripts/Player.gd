extends KinematicBody

enum {
	NONE,
	RIFLE,
	SHOTGUN,
	ROCKET_LAUNCHER	
}

enum {
	DEAD,
	ALIVE,
	SHOOTING	
}

var curWeapon = 0 #none 0; rifle 1; shotgun 2; rocket launcher 3

const CAM_WOBBLE = 0.1
const CAM_ANGLE_MAX = 85
const CAM_UNSHAKE_SPEED = 0.4

var maxHealth = 100
var health = maxHealth

#onready var settingsDebug = get_node("res://Scripts/settingsDebug")
#var speed = settingsDebug.playerSpeed
var dashSpeed = 2
var dashes = 3
var dashMax = 3
var acceleration = 3
var gravity = 17
var jump = 10

var mAcceleration = 0.1

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head = $Head
onready var camera = $Head/Camera
onready var animationPlayer = $AnimationPlayer
onready var animationPlayerDeath = $AnimationPlayerDeath
onready var animationPlayerKick = $AnimationPlayerKick
onready var jumpAudio = $JumpAudio
onready var hurtAudio = $HurtAudio
onready var deathAudio = $DeathAudio

onready var defCamTranslation = camera.translation

onready var rifleRay = $Head/Camera/RayCastRifle
onready var shotgunRay = [$Head/Camera/ShotgunRayCast/ShotgunRay1, $Head/Camera/ShotgunRayCast/ShotgunRay2, $Head/Camera/ShotgunRayCast/ShotgunRay3,
$Head/Camera/ShotgunRayCast/ShotgunRay4, $Head/Camera/ShotgunRayCast/ShotgunRay5, $Head/Camera/ShotgunRayCast/ShotgunRay6,
$Head/Camera/ShotgunRayCast/ShotgunRay7, $Head/Camera/ShotgunRayCast/ShotgunRay8, $Head/Camera/ShotgunRayCast/ShotgunRay9,
$Head/Camera/ShotgunRayCast/ShotgunRay10, $Head/Camera/ShotgunRayCast/ShotgunRay11, $Head/Camera/ShotgunRayCast/ShotgunRay12,
$Head/Camera/ShotgunRayCast/ShotgunRay13, $Head/Camera/ShotgunRayCast/ShotgunRay14, $Head/Camera/ShotgunRayCast/ShotgunRay15]

onready var launcherRay = $Head/Camera/RayCastLauncher
onready var kickRay = $Head/Camera/RayCastKick

onready var dashGUI = $Head/Camera/UI/DashGUI
onready var healthBar = $Head/Camera/UI/Healthbar
onready var weaponLabel = $Head/Camera/UI/Weapon
onready var flashLabel = $Head/Camera/UI/Flash

onready var dashTimer = $DashCooldown
onready var deathTimer = $DeathTimer
onready var flashTimer = $FlashTimer

onready var deathScreen = $DeathScreen

signal damageTaken(dmg)

signal shootDef
signal shootRifle
signal shootShotgun
signal shootLauncher
signal shootMegaPistol
signal shootRailgun

signal showDef
signal showRifle
signal showShotgun
signal showLauncher
signal showMegaPistol
signal showRailgun
signal showNone

var STATE = DEAD

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Flash("KILL")
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mAcceleration))
		head.rotate_x(deg2rad(-event.relative.y * mAcceleration))
		
		head.rotation.x = clamp(head.rotation.x, deg2rad(-CAM_ANGLE_MAX), deg2rad(CAM_ANGLE_MAX))

func _process(delta):
	
	direction = Vector3()
	camera.rotation = lerp(camera.rotation, Vector3(0, 0, 0), 0.2)
	
	if Input.is_action_just_pressed("scroll_up"):
		curWeapon += 1
		if curWeapon == 6:
			curWeapon = 0
		ChangeWeapon(curWeapon)
	elif Input.is_action_just_pressed("scroll_down"):
		curWeapon -= 1
		if curWeapon == -1:
			curWeapon = 5
		ChangeWeapon(curWeapon)
	if STATE != DEAD:
			
		if Input.is_action_pressed("moveF"):
			direction -= transform.basis.z
		elif Input.is_action_pressed("moveB"):
			direction += transform.basis.z
		
		if Input.is_action_pressed("moveR"):
			direction += transform.basis.x
			camera.rotation = lerp(camera.rotation, Vector3(0, 0, -CAM_WOBBLE), CAM_WOBBLE)
			
		elif Input.is_action_pressed("moveL"):
			direction -= transform.basis.x
			camera.rotation = lerp(camera.rotation, Vector3(0, 0, CAM_WOBBLE), CAM_WOBBLE)
			
		direction = direction.normalized() # Maybe leave this out for retro effect?
		
		velocity = velocity.linear_interpolate(direction * tweaker.playerSpeed, acceleration * delta)
		
	if Input.is_action_just_pressed("dash") and dashes > 0:
		dashes -= 1
		velocity *= dashSpeed
		fall.y = 0
		if dashTimer.is_stopped():
			dashTimer.start()
		dashGUI.UpdateDash(dashes)
	
	var snap = Vector3.DOWN * 16
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP)
	
# warning-ignore:return_value_discarded
	move_and_slide(fall, Vector3.UP)

func _physics_process(delta):
	if not is_on_floor():
		fall.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		fall.y = jump
		jumpAudio.play()
		
	if Input.is_action_pressed("shoot"):
		STATE = SHOOTING
		
		match curWeapon:
			0:
				emit_signal("shootDef")
			1:
				emit_signal("shootRifle")
			2:
				emit_signal("shootShotgun")
			3:
				emit_signal("shootLauncher")
			4:
				emit_signal("shootMegaPistol")
			5:
				emit_signal("shootRailgun")
				
	if Input.is_action_pressed("kick") and not animationPlayerKick.is_playing():
		STATE = SHOOTING
		animationPlayerKick.play("Kick")
		
		if kickRay.is_colliding(): 
			var target = kickRay.get_collider()
			
			if target.is_in_group("Enemy"):
				target.onKicked(global_transform.origin.normalized() - target.global_transform.origin.normalized())
				$Score.ChangeScore(5000)
			elif target.is_in_group("Interact"):
				target.onInteracted(self)
	else:
		STATE = ALIVE
		
	#headbob
	if direction != Vector3():
		animationPlayer.play("PlayerBob")

func ChangeWeapon(weapon):
	match weapon:
		0:
			rifleRay.enabled = true
			for raycast in shotgunRay:
				raycast.enabled = false
			launcherRay.enabled = false
			
			weaponLabel.text = "Default Pistol"
			emit_signal("showDef")
		1:
			rifleRay.enabled = true
			for raycast in shotgunRay:
				raycast.enabled = false
			launcherRay.enabled = false
			
			weaponLabel.text = "Rifle"
			
			emit_signal("showRifle")
		2:
			rifleRay.enabled = false
			for raycast in shotgunRay:
				raycast.enabled = true
				raycast.cast_to = Vector3(0,0,-tweaker.sgunRange)
			launcherRay.enabled = false
			
			weaponLabel.text = "Shotgun"
			
			emit_signal("showShotgun")
		3:
			rifleRay.enabled = false
			for raycast in shotgunRay:
				raycast.enabled = false
			launcherRay.enabled = true
			
			weaponLabel.text = "Rocket Launcher"
			
			#show rocket launcher
			emit_signal("showLauncher")
		4:
			rifleRay.enabled = true
			for raycast in shotgunRay:
				raycast.enabled = false
			launcherRay.enabled = false
			
			weaponLabel.text = "Mega Pistol"
			
			emit_signal("showMegaPistol")
		
		5:
			rifleRay.enabled = false
			for raycast in shotgunRay:
				raycast.enabled = false
			launcherRay.enabled = false
			
			weaponLabel.text = "Railgun"
			
	print("Current weapon is: " + str(weapon))

func _on_DashCooldown_timeout():
	if dashes < dashMax:
		dashes += 1
		dashGUI.UpdateDash(dashes)
	else:
		dashTimer.stop()

func onDamage(dmg):
	health -= dmg
	
	if health <= 0:
		STATE = DEAD
		gameOver()
	healthBar.onHealthUpdated(health)
	animationPlayerDeath.play("Damage")
	hurtAudio.play()
	
	emit_signal("damageTaken", dmg) 

func onHeal(hp):
	health += hp
	health = clamp(health, 0, maxHealth)
	healthBar.onHealthUpdated(health)

func gameOver():
	get_tree().paused = true
	deathAudio.play()
	deathTimer.start()
	deathScreen.visible = true

func _on_DeathTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false
	deathScreen.visible = false
	
func Flash(msg):
	flashLabel.bbcode_text = "[center]" + str(msg) + "[/center]"
	flashLabel.visible = true
	flashTimer.start()


func _on_FlashTimer_timeout():
	flashLabel.visible = false


func _on_Button_pressed():
	get_tree().quit()
