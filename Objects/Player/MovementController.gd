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

signal _crouch_down
signal _crouch_up

signal _climb_move
signal _climb_idle

@export var c_body : CharacterBody2D

@export_group("Basics")
@export var move_speed : float
@export var climb_speed : float
@export var gravity : float
@export var decelleration : float
@export var climb_decelleration : float


@export_group("Jump")
@export var jump_force : float
@export var jump_queue_length_msec : int
@export var coyote_time_length_msec : int
@export var fall_gravity_mult : float

@export_group("Dash")
@export var dash_force : float
@export var base_stamina := 1

## The jump winds up linearly with respect to these two variables.
@export_group("Jump")
@export var small_jump_force : float
@export var jump_min_force : float
@export var jump_max_force : float
@export var jump_windup_msec : float
@export var jump_hud : Node2D
@export var jump_wall_force : float

var jump_start_tick_msec : float
var jump_wall_boost : Vector2

var state_machine : StateMachine

var move_dir : Vector2
var stamina : int

var jumping : bool
var falling : bool

var jump_request_timestamp_msec : int
var jump_timestamp_msec : int
var on_ground_timestamp_msec : int

var x_facing : int

func _ready() -> void:
	print(c_body.position)
	state_machine = StateMachine.create(self)
	state_machine.add_state("Idle", idle_enter, null, idle_phys_process)
	state_machine.add_state("Move", move_enter, null, move_phys_process, move_exit)
	
	state_machine.add_state("SmallJump", small_jump_enter, null, null)
	state_machine.add_state("JumpWindup", jump_windup_enter, jump_windup_process, null, jump_windup_exit)
	state_machine.add_state("Jumping", jump_enter, null, jumping_phys_process)
	
	state_machine.add_state("AirIdle", air_idle_enter, null, air_idle_phys_process)
	state_machine.add_state("AirMove", air_move_enter, null, air_move_phys_process)
	
	state_machine.add_state("FallIdle", fall_idle_enter, null, fall_idle_phys_process)
	state_machine.add_state("FallMove", fall_move_enter, null, fall_move_phys_process)
	
	state_machine.add_state("ClimbingMove", climb_move_enter, null, climb_move_phys_process, climb_move_exit)
	state_machine.add_state("ClimbingIdle", climb_idle_enter, null, climb_idle_phys_process, climb_idle_exit)
	
	state_machine.add_state("Dash", dash_enter, null, dash_phys_process, dash_exit)
	
	state_machine.transfer("Idle")

func get_facing():
	if x_facing == Constants.RIGHT:
		return "Right"
	elif x_facing == Constants.LEFT:
		return "Left"
	else:
		return "IDK"

func _physics_process(delta: float) -> void:
	move_dir = Vector2(Input.get_axis("MoveLeft", "MoveRight"), Input.get_axis("MoveUp", "MoveDown"))
	if c_body.is_on_floor():
		stamina = base_stamina
	
	c_body.move_and_slide()
	
func apply_movement(is_climbing: bool = false):
	if is_climbing:
		if x_facing == Constants.RIGHT:
			c_body.velocity.y = -move_dir.x * climb_speed
		if x_facing == Constants.LEFT:
			c_body.velocity.y = move_dir.x * climb_speed
	else:
		if move_dir.x != 0:
			c_body.velocity.x = move_dir.x * move_speed
		if move_dir.x > 0:
			x_facing = Constants.RIGHT
		if move_dir.x < 0:
			x_facing = Constants.LEFT
			
		
	print(get_facing())


func apply_jump(jump_force: Vector2):
	print("Jumping: ", jump_force)
	c_body.velocity = jump_force

func apply_gravity(delta : float, gravity_scale := 1.0):
	c_body.velocity.y += ((gravity * gravity_scale) * delta * Engine.physics_ticks_per_second)
	
func small_jump_enter():
	var jump_vector : Vector2 = Vector2(0, -small_jump_force) + jump_wall_boost
	jump_wall_boost = Vector2.ZERO
	apply_jump(jump_vector)
	state_machine.transfer("AirMove")

func jump_windup_enter():
	jump_hud.visible = true
	jump_start_tick_msec = Time.get_ticks_msec()
	
func jump_windup_process(delta : float):
	c_body.velocity = c_body.velocity / decelleration
	var line : Line2D = jump_hud.get_node("JumpLine")
	
	var ratio_distance = min((Time.get_ticks_msec() - jump_start_tick_msec)/jump_windup_msec, 1) * 300
	var mouse_dir = c_body.get_local_mouse_position().normalized()
	
	if mouse_dir.y > -0.3:
		_crouch_down.emit()
	else:
		_crouch_up.emit()

	if mouse_dir.x < 0:
		x_facing = Constants.LEFT
	else:
		x_facing = Constants.RIGHT
		
	
	
	line.points[1] = ratio_distance * mouse_dir
		
	if Input.is_action_just_released("LongJump"):
		state_machine.transfer("Jumping")
		return
	
func jump_windup_exit():
	var jump_apply_force = min((Time.get_ticks_msec() - jump_start_tick_msec)/(jump_windup_msec), 1) * (jump_max_force - jump_min_force) + jump_min_force
	var jump_dir = Vector2.from_angle(Vector2.ZERO.angle_to_point(c_body.get_local_mouse_position())).normalized()
	apply_jump(jump_apply_force * jump_dir)
	
	jumping = true
	jump_hud.visible = false
	jump_start_tick_msec = INF

func climb_move_enter():
	jumping = false
	_climb_move.emit()
	pass


func climb_move_phys_process(delta : float):
	if move_dir.x == 0:
		state_machine.transfer("ClimbingIdle")
		return
	
	if can_jump("SmallJump", true):
		if x_facing == Constants.RIGHT: 
			x_facing = Constants.LEFT
			jump_wall_boost = Vector2.LEFT * jump_wall_force
		if x_facing == Constants.LEFT:
			x_facing = Constants.RIGHT
			jump_wall_boost = Vector2.RIGHT * jump_wall_force
		state_machine.transfer("SmallJump")
		return	
	
	if can_jump("LongJump", true):
		if x_facing == Constants.RIGHT:
			x_facing = Constants.LEFT
		if x_facing == Constants.LEFT:
			x_facing = Constants.RIGHT
		
		state_machine.transfer("JumpWindup")
		return


	apply_movement(true)
		
	if not c_body.is_on_wall():
		state_machine.transfer("Move")
		return
		
	if c_body.is_on_floor():
		state_machine.transfer("Move")
		return

func climb_move_exit():
	c_body.velocity.x = 0
	
func climb_idle_enter():
	jumping = false 
	_climb_idle.emit()
	pass

func climb_idle_phys_process(delta: float):
	if move_dir.x != 0:
		state_machine.transfer("ClimbingMove")
	
	if can_jump("SmallJump", true):
		if x_facing == Constants.RIGHT: 
			x_facing = Constants.LEFT
			jump_wall_boost = Vector2.LEFT * jump_wall_force
		if x_facing == Constants.LEFT:
			x_facing = Constants.RIGHT
			jump_wall_boost = Vector2.RIGHT * jump_wall_force
		
		state_machine.transfer("SmallJump")
		return
		
	if can_jump("LongJump", true):
		if x_facing == Constants.RIGHT:
			x_facing = Constants.LEFT
		if x_facing == Constants.LEFT:
			x_facing = Constants.RIGHT
		
		state_machine.transfer("JumpWindup")
		return

		
	c_body.velocity = c_body.velocity / climb_decelleration
	
	if not c_body.is_on_wall():
		state_machine.transfer("Move")
		return

func climb_idle_exit():
	pass


func idle_enter():
	print(c_body.position)
	_idle.emit()

func idle_phys_process(delta : float):
	if move_dir.x != 0:
		state_machine.transfer("Move")
		return
	if c_body.velocity.y > 0:
		state_machine.transfer("FallIdle")
		return
		
	c_body.velocity.x = c_body.velocity.x / decelleration
		
	apply_gravity(delta)
		
	if can_jump("SmallJump"):
		state_machine.transfer("SmallJump", "Idle")
		return
	
	if can_jump("LongJump"):
		state_machine.transfer("JumpWindup", "Idle")
		return

func move_enter():
	apply_movement()
	_move.emit()
	
func move_phys_process(delta : float):
	if move_dir.x == 0:
		state_machine.transfer("Idle")
		return
	if c_body.velocity.y > 0: 
		state_machine.transfer("FallMove")

	apply_movement()
	apply_gravity(delta)
	
	if can_jump("SmallJump"):
		state_machine.transfer("SmallJump", "Move")
		return
	
	if can_jump("LongJump"):
		state_machine.transfer("JumpWindup", "Idle")
		return
	
	if c_body.is_on_wall():
		state_machine.transfer("ClimbingIdle")
		return
		

func move_exit():
	#c_body.velocity.x = 0
	pass

func jump_enter():
	_jump_move.emit()
#	Jump will already be applied by now. This is the state that stays until the cat starts falling
	#apply_movement()
	pass
	

func jumping_phys_process(delta: float):
	if c_body.velocity.y > 0 && is_zero_approx(c_body.velocity.x):
		state_machine.transfer("AirIdle")
	if c_body.velocity.y > 0 && not is_zero_approx(c_body.velocity.x):
		state_machine.transfer("AirMove")
	if c_body.is_on_floor():
		state_machine.transfer("Move")
		return
	if c_body.is_on_wall():
		state_machine.transfer("ClimbingIdle")
		return
	
	apply_gravity(delta)

func air_idle_enter():
	_air_idle.emit()

func air_idle_phys_process(delta : float):
	apply_gravity(delta)
	
	c_body.velocity.x = c_body.velocity.x / decelleration
	
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x != 0:
		state_machine.transfer("AirMove")
	elif can_jump():
		state_machine.transfer("SmallJump")
	elif c_body.is_on_floor():
		state_machine.transfer("Idle")
	elif c_body.is_on_wall():
		state_machine.transfer("ClimbingIdle")

func air_move_enter():
	apply_movement()
	_air_move.emit()

func air_move_phys_process(delta : float):
	if can_dash():
		state_machine.transfer("Dash")
	elif move_dir.x == 0:
		state_machine.transfer("AirIdle")
	elif can_jump():
		state_machine.transfer("SmallJump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Move")
	elif c_body.is_on_wall():
		state_machine.transfer("ClimbingIdle")
	else:
		apply_movement()
		apply_gravity(delta)
		
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
		state_machine.transfer("SmallJump")
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
	elif can_jump("SmallJump"):
		state_machine.transfer("SmallJump")
	elif c_body.is_on_floor():
		_land.emit()
		state_machine.transfer("Move")
	elif c_body.is_on_wall():
		state_machine.transfer("ClimbingIdle")

func can_jump(type: String = "SmallJump", is_climbing: bool = false):
	if Input.is_action_just_pressed(type):
		jump_request_timestamp_msec = Time.get_ticks_msec()
	
	if c_body.is_on_floor():
		on_ground_timestamp_msec = Time.get_ticks_msec()
		jumping = false
		falling = false
	
	var is_on_wall = c_body.is_on_wall()
	
	var time_since_jump_request = Time.get_ticks_msec() - jump_request_timestamp_msec
	var time_since_on_ground = Time.get_ticks_msec() - on_ground_timestamp_msec
	
	return !jumping && time_since_jump_request < jump_queue_length_msec && ((time_since_on_ground < coyote_time_length_msec) || (is_on_wall && is_climbing))

func dash_enter():
	if move_dir == Vector2.ZERO:
		pass
	
	
	_dash_begin.emit()
	c_body.velocity = move_dir.normalized() * dash_force
	await get_tree().create_timer(0.2).timeout
	
	if move_dir.x == 0:
		state_machine.transfer("AirIdle", "Dash")
	else:
		state_machine.transfer("AirMove", "Dash")

func dash_phys_process(delta : float):
	if can_jump():
		state_machine.transfer("SmallJump")
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
