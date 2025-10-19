extends Control

func _input(event): # esc -> go back a menu
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
		
