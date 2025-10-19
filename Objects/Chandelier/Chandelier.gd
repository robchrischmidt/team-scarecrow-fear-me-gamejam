extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("stable")


func _on_area_2d_body_exited(body: Node2D) -> void:
	$AnimatedSprite2D.play("sway")
