class_name MovementController

extends Node

signal _idle
signal _move
signal _jump_idle
signal _jump_move
signal _air_idle
signal _air_move
signal _fall_idle
signal _fall_move
signal _land
signal _dash_begin
signal _dash_end

@export var c_body : CharacterBody2D

@export_group("Basics")
@export var move_speed : float
@export var gravity : float

@export_group("Jump")
@export var jump_force : float
@export var jump_queue_length_msec : int
@export var coyote_time_length_msec : int
@export var fall_gravity_mult : float

@export_group("Dash")
@export var dash_force : float
@export var base_stamina := 1

var state_machine : StateMachine

var move_dir : Vector2
var stamina : int

var jumping : bool
var falling : bool
var jump_request_timestamp_msec : int
var jump_timestamp_msec : int
var on_ground_timestamp_msec : int

func _ready() -> void:
	state_machine = StateMachine.create(self)
	state_machine.add_state("Idle", idle_enter, null, idle_phys_process)
	state_machine.add_state("Move", move_enter, null, move_phys_process, move_exit)
	state_machine.add_state("Jump", jump_enter, null, null)
	state_machine.add_state("AirIdle", air_idle_enter, null, air_idle_phys_process)
	state_machine.add_state("AirMove", air_move_enter, null, air_move_phys_process)
	state_machine.add_state("FallIdle", fall_idle_enter, null, fall_idle_phys_process)
	state_machine.add_state("FallMove", fall_move_enter, null, fall_move_phys_process)
	state_machine.add_state("Dash", dash_enter, null, dash_phys_process, dash_exit)
	
	state_machine.transfer("Idle")

func _physics_process(delta: float) -> void:
	move_dir = Vector2(Input.get_axis("MoveLeft", "MoveRight"), Input.get_axis("MoveUp", "MoveDown"))
	if c_body.is_on_floor():
		stamina = base_stamina
	
	c_body.move_and_slide()

func apply_movement():
	c_body.velocity.x = move_dir.x * move_speed

func apply_jump():
	c_body.velocity.y = -jump_force

func apply_gravity(delta : float, gravity_scale := 1.0):
	c_body.velocity.y += ((gravity * gravity_scale) * delta * Engine.physics_ticks_per_second)

func idle_enter():
	_idle.emit()

func idle_phys_process(delta : float):
	if move_dir.x != 0:
		state_machine.transfer("Move")
		
	apply_gravity(delta)
		
	if can_jump():
		state_machine.transfer("Jump", "Idle")
		return

func move_enter():
	_move.emit()
	
func move_phys_process(delta : float):
	if move_dir.x == 0:
		state_machine.transfer("Idle")
		return

	apply_movement()
	apply_gravity(delta)
	
	if can_jump():
		state_machine.transfer("Jump", "Move")
		return

func move_exit():
	c_body.velocity.x = 0

func jump_enter():
	jumping = true
	apply_jump()
	
	if move_dir.x != 0:
		apply_movement()
	
	if move_dir.x == 0:
		_jump_idle.emit()
		state_machine.transfer("AirIdle")
	else:
		_jump_move.emit()
		state_machine.transfer("AirMove")

func air_idle_enter():
	_air_idle.emit()

func air_idle_phys_process(delta : float):
	apply_gravity(delta)
	
	if (jumping && (c_body.velocity.y > 0 || !Input.is_action_pressed("Jump"))):
		jumping = false
		state_machine.transfer("FallIdle")
	
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x != 0:
		state_machine.transfer("AirMove")
	elif can_jump():
		state_machine.transfer("Jump")
	elif c_body.is_on_floor():
		state_machine.transfer("Idle")

func air_move_enter():
	_air_move.emit()

func air_move_phys_process(delta : float):
	apply_gravity(delta)
	apply_movement()
	
	if (jumping && (c_body.velocity.y > 0 || !Input.is_action_pressed("Jump"))):
		jumping = false
		state_machine.transfer("FallMove")
	
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x == 0:
		state_machine.transfer("AirIdle")
	elif can_jump():
		state_machine.transfer("Jump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Move")

func fall_idle_enter():
	_fall_idle.emit()
	if c_body.velocity.y < 0:
		c_body.velocity.y /= 2

func fall_idle_phys_process(delta : float):
	apply_gravity(delta, fall_gravity_mult)
	
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x != 0:
		state_machine.transfer("FallMove")
	elif can_jump():
		state_machine.transfer("Jump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Idle")

func fall_move_enter():
	_fall_move.emit()
	if c_body.velocity.y < 0:
		c_body.velocity.y /= 2
	
func fall_move_phys_process(delta : float):
	apply_gravity(delta, fall_gravity_mult)
	apply_movement()
	
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x == 0:
		state_machine.transfer("FallIdle")
	elif can_jump():
		state_machine.transfer("Jump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Move")

func can_jump():
	if Input.is_action_just_pressed("Jump"):
		jump_request_timestamp_msec = Time.get_ticks_msec()
	
	if c_body.is_on_floor():
		on_ground_timestamp_msec = Time.get_ticks_msec()
		jumping = false
		falling = false
		
	var time_since_jump_request = Time.get_ticks_msec() - jump_request_timestamp_msec
	var time_since_on_ground = Time.get_ticks_msec() - on_ground_timestamp_msec
	
	return !jumping && time_since_jump_request < jump_queue_length_msec && time_since_on_ground < coyote_time_length_msec

func dash_enter():
	_dash_begin.emit()
	c_body.velocity = move_dir.normalized() * dash_force
	await get_tree().create_timer(0.2).timeout
	
	if move_dir.x == 0:
		state_machine.transfer("AirIdle", "Dash")
	else:
		state_machine.transfer("AirMove", "Dash")

func dash_phys_process(delta : float):
	if can_jump():
		state_machine.transfer("Jump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Move")

func dash_exit():
	_dash_end.emit()
	c_body.velocity /= 2
		
func can_dash():
	if Input.is_action_just_pressed("Dash") && stamina != 0:
		stamina -= 1
		return true
	return false
