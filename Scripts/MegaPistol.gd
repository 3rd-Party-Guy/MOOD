extends Spatial

var ammo = 15
var ammoMax = 30

var headDamage = 100
var damage = 10

var MAX_CAM_SHAKE_X = 0.3
var MAX_CAM_SHAKE_Y = 0.3
var defCamTranslation

var MIN_POINTS = 450
var MAX_POINTS = 700

onready var animPlayer = $"AnimationPlayer"
onready var raycast = $"../../RayCastRifle"
onready var player = $"../../../../"
onready var audio = $Audio

onready var ammoStat = player.find_node("Ammo")

onready var camera = get_parent()

onready var bulletDecal = preload("res://Scenes/BulletDecal.tscn")
onready var blood = preload("res://Scenes/BloodSplatter.tscn")

func _ready():
	defCamTranslation = camera.translation
# warning-ignore:return_value_discarded
	player.connect("shootMegaPistol", self, "fire")
	
	player.connect("showDef", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showShotgun", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showRifle", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showLauncher", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showNone", self, "hide")
	player.connect("showMegaPistol", self, "show")

func fire():
	if not animPlayer.is_playing() and ammo != 0:
		ammo -= 1
		ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
		
		visible = true
		
		camera.translation = lerp(
		camera.translation,
		Vector3(rand_range(MAX_CAM_SHAKE_X, -MAX_CAM_SHAKE_X), defCamTranslation.y + rand_range(MAX_CAM_SHAKE_Y,-MAX_CAM_SHAKE_Y), defCamTranslation.z),				0.7)
		
		audio.pitch_scale = rand_range(0.5, 1.5)
		audio.play()
		
		if raycast.is_colliding():
			var target = raycast.get_collider()
			var head = false
			var d = bulletDecal.instance()
			
			if target.is_in_group("Enemy"):
				var b = blood.instance()
				target.add_child(b)
				
				
				b.global_transform.origin = raycast.get_collision_point()
				b.global_transform.basis = target.global_transform.basis
				b.get_node("Particles").emitting = true
				
				if raycast.get_collider_shape() == 1:
					player.Flash("Headshot")
					print("HEADSHOT!!!")
					target.health -= headDamage
				else:
					target.health -= damage
				player.get_node("Score").ChangeScore(rand_range(MIN_POINTS, MAX_POINTS))
			elif target.is_in_group("Interact"):
				target.onInteracted(player)
			else:
				target.add_child(d)
				d.global_transform.origin = raycast.get_collision_point()
				d.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
				d.global_scale((d.scale / 100) * target.scale)
				d.set_disable_scale(true)
				
		animPlayer.play("AssaultFire")
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
