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


#func handle_flip():
#	if %MovementController.x_facing == Constants.RIGHT:
#		flip_h = false
#	if %MovementController.x_facing == Constants.LEFT:
#		flip_h = true

#func _on_movement_controller__move() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("walk")

#func _on_movement_controller__idle() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("idle")

#func _on_movement_controller__air_idle() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall")

#func _on_movement_controller__air_move() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall_move")

#func _on_movement_controller__jump_idle() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall")

#func _on_movement_controller__jump_move() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall_move")

#func _on_movement_controller__fall_idle() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall")

#func _on_movement_controller__fall_move() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("fall_move")

#func _on_movement_controller__crouch_down() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("jump_prep")
#	frame=0

#func _on_movement_controller__crouch_up() -> void:
#	handle_flip()
#	speed_scale = 1
#	play("jump_prep")
#	frame=1


#func _on_movement_controller__climb_idle() -> void:
#	speed_scale = 0
#	play("climbing")


#func _on_movement_controller__climb_move() -> void:
#	speed_scale = 1
#	play("climbing")
