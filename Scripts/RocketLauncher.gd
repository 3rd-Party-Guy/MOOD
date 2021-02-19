extends Spatial

var ammo = 2
var ammoMax = 5

var damage = 10

var MAX_CAM_SHAKE_X = 0.3
var MAX_CAM_SHAKE_Y = 0.3
var defCamTranslation

var MIN_POINTS = 2000
var MAX_POINTS = 2650

onready var animPlayer = $"AnimationPlayer"
onready var raycast = $"../../RayCastRifle"
onready var player = $"../../../../"
onready var audio = $Audio

onready var ammoStat = player.find_node("Ammo")

onready var camera = get_parent()

onready var projectile = preload("res://Scenes/Projectile.tscn")
onready var bulletDecal = preload("res://Scenes/BulletDecal.tscn")

func _ready():
	defCamTranslation = camera.translation
# warning-ignore:return_value_discarded
	player.connect("shootLauncher", self, "fire")
	
	player.connect("showDef", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showShotgun", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showRifle", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showLauncher", self, "show")
# warning-ignore:return_value_discarded
	player.connect("showNone", self, "hide")

func fire():
	if not animPlayer.is_playing() and ammo != 0:
		ammo -= 1
		ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
		
		# maybe move this to section P
		var p = projectile.instance()
		add_child(p)
		p.shoot = true
		
		audio.play()
		
		camera.translation = lerp(
		camera.translation,
		Vector3(rand_range(MAX_CAM_SHAKE_X, -MAX_CAM_SHAKE_X), defCamTranslation.y + rand_range(MAX_CAM_SHAKE_Y,-MAX_CAM_SHAKE_Y), defCamTranslation.z),				0.7)
				
		if raycast.is_colliding():
			var target = raycast.get_collider()
			var d = bulletDecal.instance()
			
			target.add_child(d)
			# section P
			p.look_at(target.get_collision_point(), Vector3.UP)
			d.global_transform.origin = raycast.get_collision_point()
			d.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			d.global_scale((d.scale / 100) * target.scale)
			d.set_disable_scale(true)
				
		animPlayer.play("LauncherFire")
	else:
		camera.translation = lerp(camera.translation, defCamTranslation, 0.7)
		
func hide():
	$launcher.visible = false

func show():
	ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
	visible = true
	$launcher.visible = true

func onAddAmmo(ammoAdd):
	ammo += ammoAdd
	ammo = clamp(ammo, 0, ammoMax)
	
	if visible:
		ammoStat.bbcode_text = "[center]" + "%01d/%01d" % [ammo, ammoMax] + "[/center]"
