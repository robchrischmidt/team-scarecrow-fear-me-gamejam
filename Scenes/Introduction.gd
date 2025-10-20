extends Node2D

# Play through the intro sequence
func _ready() -> void:
	MenuMusic.player.stop()
	
	var purr_tween : Tween = create_tween()
	
	purr_tween.tween_property(%PurrPlayer, "volume_db", -5, 15)
	purr_tween.play()
	
	var tween : Tween = create_tween()
	print ("Text 1")
	
	tween.tween_property(%Text1, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	tween = create_tween()
	
	print("Text 2")
	
	tween.tween_property(%Text2, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	tween = create_tween()
	
	print("Text 3")
	
	tween.tween_property(%Text3, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	tween = create_tween()
	
	print("Text 4")

	tween.tween_property(%Text4, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	
	await get_tree().create_timer(3).timeout
	
	print("FURY")
	
	tween = create_tween()
	tween.tween_property(%Block, "modulate:a", 0.25, 4.0)
	tween.play()
	await tween.finished
	
	await get_tree().create_timer(4).timeout
	
	purr_tween.stop()
	
	get_tree().change_scene_to_file("res://Scenes/L1.tscn")

	
