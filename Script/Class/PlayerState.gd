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
const GRAVITY = 3500
const ACCELERATE_WALK = 1500
const FLOOR_DRAG = 1
const AIR_DRAG = 0.25
const MAX_X_SPEED = 200
const JUMP_SPEED = 400
const MAX_FALL_SPEED = 1000
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.15
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

# Get intended x movement direction
func get_input_direction():
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

func do_normal_x_movement(delta, friction_constant):
	if (abs(Player.velocity.x)>MAX_X_SPEED && Player.directionX == get_input_direction()): #going too fast
		Player.velocity.x = approach(Player.velocity.x, get_input_direction() * MAX_X_SPEED, delta * friction_constant)
	elif (get_input_direction()!=0): # move player
		Player.velocity.x = approach(Player.velocity.x, get_input_direction() * MAX_X_SPEED, delta * ACCELERATE_WALK)
	else:	#normal friction
		Player.velocity.x = approach(Player.velocity.x, 0, delta * friction_constant * 1000)

func do_gravity(delta, fall_acceleration, max_fall_speed):
	Player.velocity.y = approach(Player.velocity.y, max_fall_speed, delta * fall_acceleration)

# Have an integer approach another with a defined increment
func approach(to_change, maximum, change_by):
	var approach_direction = 0;
	if (maximum > to_change):
		approach_direction = 1
	elif (maximum < to_change):
		approach_direction = -1
	to_change += change_by * approach_direction;
	if (approach_direction == -1 && to_change < maximum):
		to_change = maximum
	elif (approach_direction == 1 && to_change > maximum):
		to_change = maximum
	return to_change

func start_coyote_time():
	Player.canCoyoteJump = true
	Timers.get_node("CoyoteTimer").start(COYOTE_TIME)

