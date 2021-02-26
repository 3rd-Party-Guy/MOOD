extends Spatial

var ammo = 30
var ammoMax = 90


var MAX_CAM_SHAKE_X = 1
var MAX_CAM_SHAKE_Y = 1
var defCamTranslation : Vector3

var MIN_POINTS = 2000
var MAX_POINTS = 4350

onready var animPlayer = $"AnimationPlayer"
onready var rayRotation = $"../../ShotgunRayCast"
onready var raycasts = [$"../../ShotgunRayCast/ShotgunRay1", $"../../ShotgunRayCast/ShotgunRay2", $"../../ShotgunRayCast/ShotgunRay3",$"../../ShotgunRayCast/ShotgunRay4",$"../../ShotgunRayCast/ShotgunRay5",$"../../ShotgunRayCast/ShotgunRay6",$"../../ShotgunRayCast/ShotgunRay7",$"../../ShotgunRayCast/ShotgunRay8",$"../../ShotgunRayCast/ShotgunRay9",$"../../ShotgunRayCast/ShotgunRay10",$"../../ShotgunRayCast/ShotgunRay11",$"../../ShotgunRayCast/ShotgunRay12",$"../../ShotgunRayCast/ShotgunRay13",$"../../ShotgunRayCast/ShotgunRay14",$"../../ShotgunRayCast/ShotgunRay15"]
onready var maxDamage = 120 / raycasts.size()
onready var camera = get_parent()
onready var player = $"../../../../"
onready var audio = $Audio

onready var ammoStat = player.find_node("Ammo")

onready var bulletDecal = preload("res://Scenes/BulletDecal.tscn")
onready var blood = preload("res://Scenes/BloodSplatter.tscn")

func _ready():
	defCamTranslation = camera.translation
# warning-ignore:return_value_discarded
	player.connect("shootShotgun", self, "fire")
	
	player.connect("showDef", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showRifle", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showShotgun", self, "show")
# warning-ignore:return_value_discarded
	player.connect("showLauncher", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showNone", self, "hide")

func fire():
	if not animPlayer.is_playing() and not ammo < 3:
		ammo -= 3
		ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
		
		camera.translation = lerp(
			camera.translation,
			Vector3(rand_range(MAX_CAM_SHAKE_X, -MAX_CAM_SHAKE_X), defCamTranslation.y + rand_range(MAX_CAM_SHAKE_Y,-MAX_CAM_SHAKE_Y), defCamTranslation.z),
			0.7)
			
		audio.play()
			
		for raycast in raycasts:
			if raycast.is_colliding():
				var target = raycast.get_collider()
				var d = bulletDecal.instance()
					
				target.add_child(d)
				d.global_transform.origin = raycast.get_collision_point()
				d.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				d.global_scale((d.scale / 100) * target.scale)
				d.set_disable_scale(true)
				
				if target.is_in_group("Enemy"):
					var b = blood.instance()
					target.add_child(b)
					
					b.global_transform.origin = raycast.get_collision_point()
					b.global_transform.basis = target.global_transform.basis
					b.get_node("Particles").emitting = true
					#target.health -= maxDamage + ((transform.origin.distance_to(target.transform.origin) - 1) / (50 - 1) * (100 - 10) + 10)#TODO: divide damage between distance of player and enemy
					var tempDmg = maxDamage + (-(transform.origin.distance_to(transform.origin)) * 4) #f(x) = 40+(-x)*4
					
					if tempDmg > 0:
						target.health -= tempDmg
						player.get_node("Score").ChangeScore(rand_range(MIN_POINTS, MAX_POINTS))
					elif target.is_in_group("Secret"):
						player.Flash("SECRET FOUND")
						target.onDiscovered()
				elif target.is_in_group("Interact"):
					target.onInteracted(player)
					
				rayRotation.rotate_z(deg2rad(rand_range(-360, 360)))

		animPlayer.play("ShotgunFire")
	else:
		camera.translation = lerp(camera.translation, defCamTranslation, 0.7)

func hide():
	visible = false

func show():
	ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
	visible = true

func onAddAmmo(ammoAdd):
	ammo += ammoAdd
	ammo = clamp(ammo, 0, ammoMax)
	
	if visible:
		ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
