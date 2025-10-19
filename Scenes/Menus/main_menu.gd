extends Control

#Called when the node enters the scene tree for the first time.
func _ready(): #puts focus on top button
	$VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/L1.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event): # esc -> quit
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
