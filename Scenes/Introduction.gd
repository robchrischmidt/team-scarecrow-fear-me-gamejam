extends Node2D

var wait_on_continue : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Skip"):
		get_tree().change_scene_to_file("res://Scenes/L1.tscn")
		
	if wait_on_continue && event.is_action_pressed("Continue"):
		get_tree().change_scene_to_file("res://Scenes/L1.tscn")

# Play through the intro sequence
func _ready() -> void:
	MenuMusic.player.stop()
	
	var purr_tween : Tween = create_tween()
	
	purr_tween.tween_property(%PurrPlayer, "volume_db", -5, 15)
	purr_tween.play()
	
	print ("Text 1")
	
	var tween : Tween = create_tween()
	tween.tween_property(%Text1, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	
	print("Text 2")
	
	tween = create_tween()
	tween.tween_property(%Text2, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	
	var skip_tween : Tween = create_tween()
	skip_tween.tween_property(%TextSkip, "modulate:a", 1.0, 3.0)
	skip_tween.play() # Asynchronous, no wait
	
	print("Text 3")
	
	tween = create_tween()
	tween.tween_property(%Text3, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
		
	print("Text 4")

	tween = create_tween()
	tween.tween_property(%Text4, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	
	await get_tree().create_timer(3).timeout
	
	print("FURY")
	
	tween = create_tween()
	tween.tween_property(%Block, "modulate:a", 0.25, 4.0)
	tween.play()
	await tween.finished
	
	print("Text 5")
	
	tween = create_tween()
	tween.tween_property(%Text5, "modulate:a", 1.0, 2.0)
	tween.play()
	await tween.finished
	
	print("Text 5 complete")
	
	wait_on_continue = true
