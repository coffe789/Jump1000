# Defines functions and parameters for all player states to use
extends Node
class_name PlayerState

#Nodes of global interest
#==================================================#
onready var Player = get_parent().get_parent()
onready var Audio = Player.get_node("Audio")
onready var Timers = Player.get_node("Timers")

#All constants are stored here for convenient access
#====================================================#
const GRAVITY = 25
const ACCELERATE_WALK = 100
const FLOOR_DRAG = 0.8
const AIR_DRAG = 0.9
const MAX_X_SPEED = 200
const JUMP_SPEED = 500
const MAX_FALL_SPEED = 600
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.1
const COYOTE_TIME = 0.12
const AFTER_JUMP_SLOWDOWN_FACTOR = 2
var grounded = false #should get rid of this

#Base class functions
#================================================#
# Called when state is entered. Can be given list of strings
func enter(_init_arg):
	print(self.name)

# Called when state is exited. May return a list of strings
func exit():
	pass

# Called every physics frame a state is active
func do_state_logic(_delta):
	pass

func check_for_new_state() -> String:
	return "Error: State transitions are not defined"

#Shared utility functions
#===============================================#
func check_buffered_jump_input():
	if Input.is_action_just_pressed("jump"):
		Player.isJumpBuffered = true;
		Timers.get_node("BufferedJumpTimer").start(JUMP_BUFFER_DURATION)

# Get movement inputs and set acceleration accordingly
# Maybe have the acceleration as a parameter
func get_input_direction() -> Vector2:
	var x = 0;
	if Input.is_action_pressed("right"):
		x += 1
	if Input.is_action_pressed("left"):
		x -= 1
	return x

# Decelerates the player accordingly
# Should split this so the state decides the drag factor
func apply_drag() -> void:
	if Player.is_on_floor():
		Player.velocity.x *= FLOOR_DRAG
	else:
		Player.velocity.x *= AIR_DRAG

# Keeps velocity and acceleration within defined range
# TODO: instead only clamp movement added directly from inputs
func clamp_movement() -> void:
	Player.velocity.y= clamp(Player.velocity.y, -INF,MAX_FALL_SPEED)
	Player.velocity.x = clamp(Player.velocity.x, -MAX_X_SPEED,MAX_X_SPEED)

func start_coyote_time():
	Player.canCoyoteJump = true
	Timers.get_node("CoyoteTimer").start(COYOTE_TIME)

func get_total_acceleration():
	return (Player.external_acceleration + Player.input_acceleration)

