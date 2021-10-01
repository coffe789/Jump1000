# Defines global functions for all player states to use
extends Node
class_name PlayerState

#Nodes of global interest
#==================================================#
onready var Player = get_parent().get_parent()
onready var Audio = Player.get_node("Audio")

#Required variables
#==================================================#
var next_state

#All constants are stored here for convenient access
#====================================================#
const GRAVITY = 20
const ACCELERATE_WALK = 65
const FLOOR_DRAG = 0.8
const AIR_DRAG = 0.9
const MAX_X_SPEED = 300
const JUMP_ACCELERATION = 500
const MAX_FALL_SPEED = 600
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.07
const COYOTE_TIME = 0.12
const AFTER_JUMP_DECELERATION_FACTOR = 2
var rng = RandomNumberGenerator.new() #Should do something about this later
var grounded = false #should get rid of this


# Called when state is entered. Can be given list of strings
func enter(_init_arg):
	print(self.name)

# Called when state is exited. May return a list of strings
func exit():
	pass

func _ready():
	rng.randomize() #this probably shouldn't be in this class

# Called every physics frame a state is active
func do_state_logic(_delta):
	pass

func check_for_new_state() -> String:
	return "Error: State transitions are not defined"


func check_buffered_jump_input():
	if Input.is_action_just_pressed("jump"):
		Player.isJumpBuffered = true;
		Player.get_node("Timers/BufferedJumpTimer").start(JUMP_BUFFER_DURATION)

# Get movement inputs and set acceleration accordingly
# Maybe have the acceleration as a parameter
func apply_directional_input() -> void:
	if Input.is_action_pressed("right"):
		Player.acceleration.x += ACCELERATE_WALK
	if Input.is_action_pressed("left"):
		Player.acceleration.x -= ACCELERATE_WALK
	if Input.is_action_pressed("down"):
		pass
	if Input.is_action_pressed("up"):
		pass


# Decelerates the player accordingly
# Should split this so the state decides the drag factor
func apply_drag() -> void:
	Player.velocity = Vector2()
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
