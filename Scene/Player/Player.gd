extends KinematicBody2D

const GRAVITY = 20
export var velocity = Vector2(0,0);
export var acceleration = Vector2(0,0)
const ACCELERATE_WALK = 85
const FLOOR_DRAG = 0.8
const AIR_DRAG = 0.9
const MAX_X_SPEED = 400
const JUMP_ACCELERATION = 600
const MAX_FALL_SPEED = 600
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


var isJumpBuffered = false # Needs to be global so that it persists with timer.

func doBufferJump() -> bool:
	var justJumpBuffered = false
	if isJumpBuffered && is_on_floor():
		justJumpBuffered = true
		isJumpBuffered = false
		acceleration.y -= JUMP_ACCELERATION
	elif Input.is_action_just_pressed("jump") && !is_on_floor() \
	and !isJumpBuffered:
		isJumpBuffered = true;
		yield(get_tree().create_timer(JUMP_BUFFER_DURATION),"timeout")
		isJumpBuffered = false
	return justJumpBuffered

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump(justJumpBuffered) -> void:
	if ((Input.is_action_just_released("jump") && acceleration.y < 0)) \
	or (justJumpBuffered && !Input.is_action_pressed("jump")): #release jump when going up
		acceleration.y /= 2;

# Get movement inputs and move the player accordingly
# If jump in midair, set isJumpBuffered flag
func get_movement_input() -> void:
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		acceleration.x += ACCELERATE_WALK
	if Input.is_action_pressed("left"):
		acceleration.x -= ACCELERATE_WALK
	if Input.is_action_pressed("down"):
		pass
	if Input.is_action_pressed("up"):
		pass
	if (Input.is_action_just_pressed("jump") && is_on_floor()):
		acceleration.y -= JUMP_ACCELERATION
	# End jump when let go of jump button, or if performing minimum buffer jump


func apply_drag() -> void:
	if is_on_floor():
		acceleration.x *= FLOOR_DRAG
	else:
		acceleration.x *= AIR_DRAG

func clamp_movement() -> void:
	acceleration.y= clamp(acceleration.y, -INF,MAX_FALL_SPEED)
	velocity.x = clamp(velocity.x, -MAX_X_SPEED,MAX_X_SPEED)
	acceleration.x = clamp(acceleration.x, -MAX_X_SPEED,MAX_X_SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if is_on_floor():
		acceleration.y=0
	get_movement_input()
	var justJumpBuffered = doBufferJump()
	check_if_finish_jump(justJumpBuffered)
	apply_drag()
	acceleration.y += GRAVITY
	clamp_movement()
	velocity += acceleration
	
	velocity = move_and_slide(velocity,UP_DIRECTION)

