extends Node

@export var sprite : Sprite2D
@export var speaker : AudioStreamPlayer
@export var debug : bool

@export_group("Effects")
@export var enable_sound : bool
@export var enable_animation : bool
@export var enable_particals : bool

@export_group("Sound")
@export var move_sound : AudioStream
@export var jump_sound : AudioStream
@export var land_sound : AudioStream
@export var dash_sound : AudioStream

@export_group("Animations")
@export var idle_anim : Anim
@export var move_anim : Anim
@export var jump_anim : Anim
@export var fall_anim : Anim
@export var land_anim : Anim
@export var dash_anim : Anim

@export_group("Particals")
@export var idle_partical : CPUParticles2D
@export var move_partical : CPUParticles2D
@export var jump_partical : CPUParticles2D
@export var fall_partical : CPUParticles2D
@export var land_partical : CPUParticles2D
@export var dash_partical : CPUParticles2D

var current_anim : Anim

func _idle() -> void:
	if debug: print("Idle")
	if enable_animation && idle_anim: play_animation(idle_anim)
	if enable_particals && idle_partical: idle_partical.emitting = true

func _move() -> void:
	if debug: print("Move")
	if enable_sound && move_sound: play_sound(move_sound)
	if enable_animation && move_anim: play_animation(move_anim)
	if enable_particals && move_partical: move_partical.emitting = true

func _jump_idle() -> void:
	if debug: print("Jump Idle")
	if enable_sound && jump_sound: play_sound(jump_sound)
	if enable_animation && jump_anim: play_animation(jump_anim)
	if enable_particals && jump_partical: jump_partical.emitting = true

func _jump_move() -> void:
	if debug: print("Jump Move")
	if enable_sound && jump_sound: play_sound(jump_sound)
	if enable_animation && jump_anim: play_animation(jump_anim)
	if enable_particals && jump_partical: jump_partical.emitting = true

func _air_idle() -> void:
	if debug: print("Air Idle")

func _air_move() -> void:
	if debug: print("Air Move")

func _fall_idle() -> void:
	if debug: print("Fall Idle")
	if enable_animation && fall_anim: play_animation(fall_anim)
	if enable_particals && fall_partical: fall_partical.emitting = true

func _fall_move() -> void:
	if debug: print("Fall Move")
	if enable_animation && fall_anim: play_animation(fall_anim)

func _land() -> void:
	if debug: print("Land")
	if enable_sound && land_sound: play_sound(land_sound)
	if enable_animation && land_anim: play_animation(land_anim)
	if enable_particals && land_partical: land_partical.emitting = true

func _dash_begin() -> void:
	if debug: print("Dash Begin")
	if enable_sound && dash_sound: play_sound(dash_sound)
	if enable_animation && dash_anim: play_animation(dash_anim)
	if enable_particals && dash_partical: dash_partical.emitting = true

func _dash_end() -> void:
	if debug: print("Dash End")
	
func play_sound(audio_stream, offset := 0.0):
	speaker.stream = audio_stream
	speaker.play(offset)

var tween_x : MethodTweener
var tween_y : MethodTweener
func play_animation(anim : Anim):
	print("Play animation")
	
	if anim.x_scale:
		if anim.loop:
			tween_x = create_tween().set_loops(0).tween_method(func(val): sprite.scale.x = anim.x_scale.sample(val), anim.x_scale.min_domain, anim.x_scale.max_domain, anim.x_scale.get_domain_range())
		else:
			tween_x = create_tween().tween_method(func(val): sprite.scale.x = anim.x_scale.sample(val), anim.x_scale.min_domain, anim.x_scale.max_domain, anim.x_scale.get_domain_range())
	if anim.y_scale:
		if anim.loop:
			tween_y = create_tween().set_loops(0).tween_method(func(val): sprite.scale.y = anim.y_scale.sample(val), anim.y_scale.min_domain, anim.y_scale.max_domain, anim.y_scale.get_domain_range())
		else:
			tween_y = create_tween().tween_method(func(val): sprite.scale.y = anim.y_scale.sample(val), anim.y_scale.min_domain, anim.y_scale.max_domain, anim.y_scale.get_domain_range())
