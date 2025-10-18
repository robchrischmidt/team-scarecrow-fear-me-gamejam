extends AnimatedSprite2D

func _on_movement_controller__move() -> void:
	play("walk")
	pass # Replace with function body.

func _on_movement_controller__idle() -> void:
	play("idle")
	pass # Replace with function body.

func _on_movement_controller__air_idle() -> void:
	play("fall")
	pass # Replace with function body.

func _on_movement_controller__air_move() -> void:
	play("fall_move")
	pass # Replace with function body.


func _on_movement_controller__jump_idle() -> void:
	play("fall")
	pass # Replace with function body.

func _on_movement_controller__jump_move() -> void:
	play("fall_move")
	pass # Replace with function body.

func _on_movement_controller__fall_idle() -> void:
	play("fall")
	pass # Replace with function body.

func _on_movement_controller__fall_move() -> void:
	play("fall_move")
	pass # Replace with function body.
