extends Spatial

var ammo = 10
var ammoMax = 20

var damage = 100

var MAX_CAM_SHAKE_X = 0.3
var MAX_CAM_SHAKE_Y = 0.3
var defCamTranslation

var MIN_POINTS = 450
var MAX_POINTS = 700

onready var animPlayer = $"AnimationPlayer"
onready var player = $"../../../../"
onready var audio = $Audio

onready var ammoStat = player.find_node("Ammo")
onready var rail = preload("res://Scenes/Rail.tscn")

onready var camera = get_parent()

onready var bulletDecal = preload("res://Scenes/BulletDecal.tscn")
onready var blood = preload("res://Scenes/BloodSplatter.tscn")

func _ready():
	defCamTranslation = camera.translation
# warning-ignore:return_value_discarded
	player.connect("shootRailgun", self, "fire")
	
	player.connect("showDef", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showShotgun", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showRifle", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showLauncher", self, "hide")
# warning-ignore:return_value_discarded
	player.connect("showNone", self, "hide")
	player.connect("showMegaPistol", self, "hide")
	player.connect("showRailgun", self, "show")

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
		
		#if raycast:...
		var r = rail.instance()
		$Spawn.add_child(r)
		
		r.connect("body_entered", self, "onRail")
		var new_parent = get_tree()
		r.get_parent().remove_child(r)
		new_parent.add_child(r)
		
		#r.global_transform.origin.y += 10
		 
		animPlayer.play("AssaultFire")
		#else:
		camera.translation = lerp(camera.translation, defCamTranslation, 0.7)
		
func onRail(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
	
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
