extends Node2D

@onready var game = $".."



func _on_enter_body_entered(body: Node2D) -> void:
	game.toggle_shadows(.2)

func _on_exit_body_entered(body: Node2D) -> void:
	game.toggle_shadows(.2)

func _on_off_failsafe_body_entered(body: Node2D) -> void:
	#pass
	if game.SHADOWS_ON:
		game.toggle_shadows(0)

func _on_on_failsafe_body_entered(body: Node2D) -> void:
	#pass
	if !game.SHADOWS_ON:
		game.toggle_shadows(0)
