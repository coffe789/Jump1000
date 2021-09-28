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
func _ready():
	pass

var isJumpBuffered = false
# Get movement inputs and move the player accordingly
# Also causes you to jump if a jump is buffered, may want to make this separate
func get_input():
	var justJumpBuffered = false
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
		isJumpBuffered = false
		acceleration.y -= JUMP_ACCELERATION
	# Perform buffer jump
	if isJumpBuffered && is_on_floor():
		justJumpBuffered = true
		isJumpBuffered = false
		acceleration.y -= JUMP_ACCELERATION
	elif Input.is_action_just_pressed("jump") && !is_on_floor():
		isJumpBuffered = true;
		yield(get_tree().create_timer(JUMP_BUFFER_DURATION),"timeout")
		isJumpBuffered = false
	# End jump when let go of jump button, or if performing minimum buffer jump
	if (Input.is_action_just_released("jump") && acceleration.y < 0) || (justJumpBuffered && !Input.is_action_pressed("jump")): #release jump when going up
		acceleration.y /= 2;
	
func apply_drag():
	if is_on_floor():
		acceleration.x *= FLOOR_DRAG
	else:
		acceleration.x *= AIR_DRAG

func clamp_movement():
	acceleration.y= clamp(acceleration.y, -INF,MAX_FALL_SPEED)
	velocity.x = clamp(velocity.x, -MAX_X_SPEED,MAX_X_SPEED)
	acceleration.x = clamp(acceleration.x, -MAX_X_SPEED,MAX_X_SPEED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_floor():
		acceleration.y=0
	get_input()
	apply_drag()
	acceleration.y += GRAVITY
	clamp_movement()
	velocity += acceleration
	
	velocity = move_and_slide(velocity,UP_DIRECTION)

func _on_Timer_timeout():
	print("we timing")
