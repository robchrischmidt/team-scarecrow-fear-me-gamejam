extends Control

@export var fade_duration : float
@export var fade_intensity : float

var audio_tween : Tween

#Called when the node enters the scene tree for the first time.
func _ready(): #puts focus on top button
	$VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	audio_tween = create_tween()
	audio_tween.tween_method(audio_fade, 0.0, 1.0, fade_duration)
	audio_tween.play()
	await audio_tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/L1.tscn")

func audio_fade(ratio : float):
	%MainThemePlayer.volume_db = -fade_intensity*ratio
	

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event): # esc -> quit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
