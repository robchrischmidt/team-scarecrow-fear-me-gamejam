extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
