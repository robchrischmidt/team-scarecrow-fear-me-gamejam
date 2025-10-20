extends Sprite2D

func _input(event: InputEvent) -> void:
	if event.is_action("Continue") && %Area2D.has_overlapping_bodies():
#		Check if player has all items
		var player = get_tree().get_first_node_in_group("player")
		var can_end = player.has_horns and player.has_eyes and player.has_knife
		if can_end:
			get_tree().change_scene_to_file("res://Scenes/Ending.tscn")
		else:
			%Nope.modulate.a = 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(%ContinueText, "modulate:a", 1.0, 0.5)
	tween.play()
	await tween.finished


func _on_area_2d_body_exited(body: Node2D) -> void:
	%ContinueText.modulate.a = 0
