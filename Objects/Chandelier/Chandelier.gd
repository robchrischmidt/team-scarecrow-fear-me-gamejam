extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.play("sway")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Start sway")
		$AnimatedSprite2D.play("stable")


func _process(delta : float) -> void:
	var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
	if player.global_position.y > $CollisionShape2D.global_position.y: 
		collision_layer = 0
		collision_mask = 0
	else:
		collision_layer = 1
		collision_mask = 1
