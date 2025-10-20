extends Node2D

@onready var player = $Player
var fade_tween : Tween
var SHADOWS_ON : bool = false

func _ready() -> void:
	MenuMusic.player.stop()
	
	print("Tweening")
	
	var tween : Tween = create_tween()
	tween.tween_property(%LevelMusic, "volume_db", -10, 10)
	tween.play()
	
	await tween.finished
	
	print("Tween complete")

func toggle_shadows(dur: float):
	if SHADOWS_ON:
		SHADOWS_ON = false
		fade_out(dur)
	else:
		SHADOWS_ON = true
		fade_in(dur)

func fade_in(dur : float):
	if fade_tween: fade_tween.kill()
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property($Shadows, "color", Color("36000e"), dur)
	fade_tween.finished.connect(func(): player.light.set_visible(true))

func fade_out(dur : float):
	if fade_tween: fade_tween.kill()
	fade_tween = get_tree().create_tween()
	fade_tween.tween_property($Shadows, "color", Color.WHITE, dur)
	player.light.set_visible(false)
	#fade_tween.finished.connect(func(): player.light.set_visible(false))
	
