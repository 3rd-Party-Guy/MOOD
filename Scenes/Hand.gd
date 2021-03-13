extends Spatial

var mouse_mov
export var sway_treshhold = 5
export var sway_lerp = 2

export var sway_left : Vector3
export var sway_right : Vector3
export var sway_normal : Vector3


func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _process(delta):
	if mouse_mov != null:
		if mouse_mov > sway_treshhold:
			rotation = rotation.linear_interpolate(sway_left, sway_lerp * delta)
		elif mouse_mov < -sway_treshhold:
			rotation = rotation.linear_interpolate(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.linear_interpolate(sway_normal, sway_lerp * delta)
