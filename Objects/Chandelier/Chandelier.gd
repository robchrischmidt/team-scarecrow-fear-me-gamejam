extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.get_instance_id() == $"../Player".get_instance_id()):
		$AnimatedSprite2D.play("stable")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.get_instance_id() == $"../Player".get_instance_id()):
		$AnimatedSprite2D.play("sway")
