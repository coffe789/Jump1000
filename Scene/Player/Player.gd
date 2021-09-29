extends KinematicBody2D

onready var JumpAudio = get_node("JumpAudio")
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
const JUMP_BUFFER_DURATION = 0.15
const COYOTE_TIME = 0.12
var rng = RandomNumberGenerator.new()
var grounded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()

func play_jump_audio():
	#JumpAudio.pitch_scale = rng.randf_range(1.2, 0.9)
	JumpAudio.play(0.001)

var isJumpBuffered = false # Needs to be global so that it persists with timer.
# Sets buffer jump flag, and initiates buffer jump if conditions are set
func doBufferJump() -> bool:
	var justJumpBuffered = false
	if isJumpBuffered && grounded && acceleration.y >= 0:
		justJumpBuffered = true
		isJumpBuffered = false
		acceleration.y -= JUMP_ACCELERATION
		play_jump_audio()
	elif Input.is_action_just_pressed("jump") && !grounded \
	and !isJumpBuffered:
		isJumpBuffered = true;
		yield(get_tree().create_timer(JUMP_BUFFER_DURATION),"timeout")
		isJumpBuffered = false
	return justJumpBuffered

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump(justJumpBuffered) -> void:
	if ((Input.is_action_just_released("jump") && acceleration.y < 0)) \
	or (justJumpBuffered && !Input.is_action_pressed("jump")):
		acceleration.y /= 2;

# Get movement inputs and set acceleration accordingly
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
	if (Input.is_action_just_pressed("jump") && grounded && acceleration.y >= 0):
		acceleration.y -= JUMP_ACCELERATION
		play_jump_audio()


# Decelerates the player accordingly
func apply_drag() -> void:
	if is_on_floor():
		acceleration.x *= FLOOR_DRAG
	else:
		acceleration.x *= AIR_DRAG

# Keeps velocity and acceleration within defined range
# TODO: instead only clamp movement added directly from inputs
func clamp_movement() -> void:
	acceleration.y= clamp(acceleration.y, -INF,MAX_FALL_SPEED)
	velocity.x = clamp(velocity.x, -MAX_X_SPEED,MAX_X_SPEED)
	acceleration.x = clamp(acceleration.x, -MAX_X_SPEED,MAX_X_SPEED)

# Controls every aspect of player physics
func _physics_process(delta) -> void:
	if is_on_floor():
		acceleration.y=0
		grounded=true
		$CoyoteTimer.start(COYOTE_TIME)
	get_movement_input()
	var justJumpBuffered = doBufferJump()
	check_if_finish_jump(justJumpBuffered)
	apply_drag()
	acceleration.y += GRAVITY
	clamp_movement()
	velocity += acceleration
	velocity = move_and_slide(velocity,UP_DIRECTION)


func _on_coyote_timeout():
	if !is_on_floor():
		grounded = false
