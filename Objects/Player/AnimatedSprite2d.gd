extends AnimatedSprite2D
@export var c_body : CharacterBody2D
@export var knife : AnimatedSprite2D
@export var horns : AnimatedSprite2D
@export var eyes : AnimatedSprite2D

const knifeOffsetX = -26
const hornOffsetX = 12
func _process(delta: float) -> void:
	if c_body.velocity.x > 0:
		flip_h = false
		knife.flip_h = false
		knife.offset.x = knifeOffsetX
		horns.flip_h = false
		horns.offset.x = hornOffsetX
		eyes.flip_h = false		
	if c_body.velocity.x < 0:
		flip_h = true
		knife.flip_h = true
		knife.offset.x = -knifeOffsetX
		horns.flip_h = true
		horns.offset.x = -hornOffsetX
		eyes.flip_h = true		
	pass
	
func play_anims(name) ->void:
	play(name)
	knife.play(name)
	horns.play(name)	
	eyes.play(name)	
	pass
func _on_movement_controller__move() -> void:
	play_anims("walk")
	pass # Replace with function body.

func _on_movement_controller__idle() -> void:
	play_anims("idle")
	pass # Replace with function body.

func _on_movement_controller__air_idle() -> void:
	play_anims("fall")
	pass # Replace with function body.

func _on_movement_controller__air_move() -> void:
	play_anims("fall_move")
	pass # Replace with function body.


func _on_movement_controller__jump_idle() -> void:
	play_anims("fall")
	pass # Replace with function body.

func _on_movement_controller__jump_move() -> void:
	play_anims("fall_move")
	pass # Replace with function body.

func _on_movement_controller__fall_idle() -> void:
	play_anims("fall")
	pass # Replace with function body.

func _on_movement_controller__fall_move() -> void:
	play_anims("fall_move")
	pass # Replace with function body.
