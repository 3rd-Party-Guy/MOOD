extends Area

func _on_End_body_entered(body):
	if body.is_in_group("Player"):
		body.find_node("End").visible = true
