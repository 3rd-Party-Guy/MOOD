extends Area

func _on_SecretTeleport_body_entered(body):
	if body.is_in_group("Player"):
		body.global_transform.origin = $Spatial.global_transform.origin
