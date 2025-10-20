extends Node2D

func _ready() -> void:
	MenuMusic.player.stop()
	
	print("Tweening")
	
	var tween : Tween = create_tween()
	tween.tween_property(%LevelMusic, "volume_db", -10, 10)
	tween.play()
	
	await tween.finished
	
	print("Tween complete")


func _on_player__pickup() -> void:
	if %Player.has_eyes:
		%DarkRoom.color = Color(20, 20, 20, 0)
