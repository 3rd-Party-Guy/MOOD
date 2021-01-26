extends HBoxContainer

onready var dash1 = $Sprite
onready var dash2 = $Sprite2
onready var dash3 = $Sprite3

func UpdateDash(num : int):
	match num:
		0:
			dash1.visible = false
			dash2.visible = false
			dash3.visible = false
		1:
			dash1.visible = true
			dash2.visible = false
			dash3.visible = false
		2:
			dash1.visible = true
			dash2.visible = true
			dash3.visible = false
		3:
			dash1.visible = true
			dash2.visible = true
			dash3.visible = true
