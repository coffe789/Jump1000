# Defines functions and parameters for all player states to use
extends Node
class_name PlayerState

# Nodes of global interest
#==================================================#
onready var Player = get_parent().get_parent()
onready var Audio = Player.get_node("Audio")
onready var Timers = Player.get_node("Timers")
onready var Player_Sprite = Player.get_node("Sprite")
onready var Animation_Player = Player.get_node("AnimationPlayer")
onready var Collision_Body = Player.get_node("CollisionBody")
onready var Ducking_Collision_Body = Player.get_node("DuckingCollisionBody")

# Constants
#====================================================#
const GRAVITY = 3500/2
const ACCELERATE_WALK = 1500/1.5
const FLOOR_DRAG = 1
const DUCK_FLOOR_DRAG = 0.8
const AIR_DRAG = 0.2
const MAX_X_SPEED = 200/2
const JUMP_SPEED = 400/1.9
const MAX_FALL_SPEED = 1000/2
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.15
const COYOTE_TIME = 0.12
const AFTER_JUMP_SLOWDOWN_FACTOR = 2
const WALL_GRAVITY_FACTOR = 0.01
const WALLJUMP_X_SPEED_MULTIPLIER = 1.3
const WALLJUMP_SLOWDOWN_MULTIPLIER = 0.25

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
	if Input.is_action_pressed("right") && Input.is_action_pressed("left"):
		return 0
	if Input.is_action_pressed("right"):
		x += 1
	if Input.is_action_pressed("left"):
		x -= 1
	return x

func do_normal_x_movement(delta, friction_constant, walk_acceleration):
	if (abs(Player.velocity.x)>MAX_X_SPEED && Player.directionX == get_input_direction()): #going too fast
		Player.velocity.x = approach(Player.velocity.x, get_input_direction() * MAX_X_SPEED, delta * friction_constant * 1000)
	elif (get_input_direction()!=0 && walk_acceleration > 0): # move player
		Player.velocity.x = approach(Player.velocity.x, get_input_direction() * MAX_X_SPEED, delta * walk_acceleration)
	else:	#normal friction
		Player.velocity.x = approach(Player.velocity.x, 0, delta * friction_constant * 1000)


func do_gravity(delta, fall_acceleration, max_fall_speed):
	Player.velocity.y = approach(Player.velocity.y, max_fall_speed, delta * fall_acceleration)

# Have a number approach another with a defined increment
func approach(to_change, maximum, change_by):
	assert(change_by>=0)
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

#Changes facing direction if an input is pressed. Otherwise facing remains as is.
func set_facing_direction():
	if get_input_direction()==1:
		Player.facing = 1
	if get_input_direction() == -1:
		Player.facing = -1

func set_cape_acceleration():
	Player.Cape.accel = Vector2(-Player.facing * 4, 8)

func set_player_sprite_direction():
	if Player.facing == -1:
		Player_Sprite.flip_h = false
	elif Player.facing == 1:
		Player_Sprite.flip_h = true

func can_wall_jump():
	_update_wall_direction()
	# If we're facing the direction with a valid wall
	if Player.facing == Player.wall_direction:
		return true
	return false
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(Player.left_wall_raycast)
	var is_near_wall_right = _check_is_valid_wall(Player.right_wall_raycast)
	
	# If the player is sandwiched between two walls, set the wall direction to whatever they face
	if is_near_wall_left && is_near_wall_right:
		Player.wall_direction = Player.facing
	# If we're near a left wall, wall_direction will be -(1)+(0), right wall will be -(0)+(1), neither is 0
	else:
		Player.wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)

func _check_is_valid_wall(raycast):
	if raycast.is_colliding():
		var object = raycast.get_collider()
		if object is RigidBody2D or object is StaticBody2D:
			# Check if we're on a slope
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			# If the slope is 60 degrees either way (flipping direction changes the angle, so we need two checks)
			if dot > PI * 0.35 && dot < PI * 0.55:
				return true
	return false

