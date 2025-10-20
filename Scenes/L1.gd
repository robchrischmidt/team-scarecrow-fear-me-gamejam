extends Node2D

func _ready() -> void:
	MenuMusic.player.stop()
	
	print("Tweening")
	
	var tween : Tween = create_tween()
	tween.tween_property(%LevelMusic, "volume_db", -10, 10)
	tween.play()
	
	await tween.finished
	
	print("Tween complete")
