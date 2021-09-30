# Defines global functions for all player states to use
extends Node
class_name PlayerState
onready var Player = get_parent().get_parent()
onready var Audio = Player.get_node("Audio")

#All constants are stored here for convenient access
#====================================================#
const GRAVITY = 20
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


# Called when state is entered. Can be given list of string arguments
func enter(_argv):
	print(self)

# Called when state is exited. Can be given list of string arguments
func exit(_argv):
	pass

func _ready():
	rng.randomize()

func _physics_process(_delta):
	pass

func get_inputs():
	pass

func play_jump_audio():
	#JumpAudio.pitch_scale = rng.randf_range(1.2, 0.9)
	Audio.get_node("JumpAudio").play(0.001)

var isJumpBuffered = false # Needs to be global so that it persists with timer.
# Sets buffer jump flag, and initiates buffer jump if conditions are set
func doBufferJump() -> bool:
	var justJumpBuffered = false
	if isJumpBuffered && grounded && Player.acceleration.y >= 0:
		justJumpBuffered = true
		isJumpBuffered = false
		Player.acceleration.y -= JUMP_ACCELERATION
		play_jump_audio()
	elif Input.is_action_just_pressed("jump") && !grounded \
	and !isJumpBuffered:
		isJumpBuffered = true;
		yield(get_tree().create_timer(JUMP_BUFFER_DURATION),"timeout")
		isJumpBuffered = false
	return justJumpBuffered

# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump(justJumpBuffered) -> void:
	if ((Input.is_action_just_released("jump") && Player.acceleration.y < 0)) \
	or (justJumpBuffered && !Input.is_action_pressed("jump")):
		Player.acceleration.y /= 2;

# Get movement inputs and set acceleration accordingly
func get_movement_input() -> void:
	Player.velocity = Vector2()
	if Input.is_action_pressed("right"):
		Player.acceleration.x += ACCELERATE_WALK
	if Input.is_action_pressed("left"):
		Player.acceleration.x -= ACCELERATE_WALK
	if Input.is_action_pressed("down"):
		pass
	if Input.is_action_pressed("up"):
		pass
	if (Input.is_action_just_pressed("jump") && grounded && Player.acceleration.y >= 0):
		Player.acceleration.y -= JUMP_ACCELERATION
		play_jump_audio()


# Decelerates the player accordingly
func apply_drag() -> void:
	if Player.is_on_floor():
		Player.acceleration.x *= FLOOR_DRAG
	else:
		Player.acceleration.x *= AIR_DRAG

# Keeps velocity and acceleration within defined range
# TODO: instead only clamp movement added directly from inputs
func clamp_movement() -> void:
	Player.acceleration.y= clamp(Player.acceleration.y, -INF,MAX_FALL_SPEED)
	Player.velocity.x = clamp(Player.velocity.x, -MAX_X_SPEED,MAX_X_SPEED)
	Player.acceleration.x = clamp(Player.acceleration.x, -MAX_X_SPEED,MAX_X_SPEED)
