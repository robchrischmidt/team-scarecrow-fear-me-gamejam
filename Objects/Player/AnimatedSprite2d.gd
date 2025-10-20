extends AnimatedSprite2D
@export var c_body : CharacterBody2D
@export var knife : AnimatedSprite2D
@export var horns : AnimatedSprite2D
@export var eyes : AnimatedSprite2D

const knifeOffsetX = -26
const hornOffsetX = 12

var cur_anim_name : String
var cur_anim_speed : float
var cur_anim_frame_num : int

func handle_flip(invert_flip : bool = false):
	var flip : bool = %MovementController.x_facing == Constants.LEFT
	if invert_flip:
		flip = not flip
	flip_h = flip
	knife.flip_h = flip
	horns.flip_h = flip
	eyes.flip_h = flip
	
	if flip:
		knife.offset.x = -knifeOffsetX
		horns.offset.x = -hornOffsetX
	else:
		knife.offset.x = knifeOffsetX
		horns.offset.x = hornOffsetX

func play_anims(name, speed : float, frame_num: int = -1, invert_flip : bool = false) ->void:
	cur_anim_name = name
	cur_anim_speed = speed
	cur_anim_frame_num = frame_num
	
	handle_flip(invert_flip)
	
	knife.visible = c_body.has_knife
	horns.visible = c_body.has_horns
	eyes.visible = c_body.has_eyes
	
	if frame_num != -1:
		frame = frame_num
		knife.frame = frame_num
		horns.frame = frame_num
		eyes.frame = frame_num
	speed_scale = speed
	knife.speed_scale = speed
	horns.speed_scale = speed
	eyes.speed_scale = speed
	play(name)
	knife.play(name)
	horns.play(name)	
	eyes.play(name)	
	pass

func _on_movement_controller__move() -> void:
	play_anims("walk", 1)

func _on_movement_controller__idle() -> void:
	play_anims("idle", 1)

func _on_movement_controller__air_idle() -> void:
	play_anims("fall", 1)

func _on_movement_controller__air_move() -> void:
	play_anims("fall_move", 1)

func _on_movement_controller__jump_idle() -> void:
	play_anims("fall_move", 1)

func _on_movement_controller__jump_move() -> void:
	play_anims("fall_move", 1)

func _on_movement_controller__fall_idle() -> void:
	play_anims("fall", 1)

func _on_movement_controller__fall_move() -> void:
	play_anims("fall_move", 1)

func _on_movement_controller__crouch_down() -> void:
	play_anims("jump_prep", 1, 0)

func _on_movement_controller__crouch_up() -> void:
	play_anims("jump_prep", 1, 1)

func _on_movement_controller__crouch_wall() -> void:
	play_anims("jump_prep", 1, 2, true)

func _on_movement_controller__climb_idle() -> void:
	play_anims("climb", 0)

func _on_movement_controller__climb_move() -> void:
	play_anims("climb", 1)


func _on_player__pickup() -> void:
	play_anims(cur_anim_name, cur_anim_speed, cur_anim_frame_num)
