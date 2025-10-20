extends Control

@export var fade_duration : float
@export var fade_intensity : float

var audio_tween : Tween

var player : AudioStreamPlayer

#Called when the node enters the scene tree for the first time.
func _ready(): #puts focus on top button
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	audio_tween = create_tween()
	audio_tween.tween_method(audio_fade, 0.0, 1.0, fade_duration)
	audio_tween.play()
	await audio_tween.finished
	
	MenuMusic.player.stop()
	
	get_tree().change_scene_to_file("res://Scenes/Introduction.tscn")

func audio_fade(ratio : float):
	MenuMusic.player.volume_db = -fade_intensity*ratio

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/controlmenu.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event): # esc -> quit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
