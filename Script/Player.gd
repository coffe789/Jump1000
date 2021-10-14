extends KinematicBody2D

export var velocity = Vector2(0,0);
var isJumpBuffered = false;
var canCoyoteJump = false;
var directionX = 0; #Direction player is currently moving
var directionY = 0;
var facing = 1 #either -1 or 1
var current_state = "idle";
onready var Cape = get_parent().get_node("VerletArea")

var wall_direction = 1
onready var left_wall_raycast = $WallRaycasts/LeftWallRaycast
onready var right_wall_raycast = $WallRaycasts/RightWallRaycast

onready var state_list = \
{
	"jumping" : $StateMachine/jumping,
	"idle" : 	$StateMachine/idle,
	"running" : $StateMachine/running,
	"falling" : $StateMachine/falling,
	"walljumping" : $StateMachine/walljumping
}

# Controls every aspect of player physics
func _physics_process(delta) -> void:
	state_list[current_state].set_facing_direction()
	directionX = sign(velocity.x)
	directionY = -sign(velocity.y)
	state_list[current_state].do_state_logic(delta)
	state_list[current_state].set_cape_acceleration()
	state_list[current_state].set_player_sprite_direction()
	try_state_transition()

# Changes state if the current state wants to
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	if next_state != current_state:
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state

func can_wall_jump():
	_update_wall_direction()
	# If we're facing the direction with a valid wall
	if facing == wall_direction:
		return true
	return false
	
func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycast)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycast)
	
	# If the player is sandwiched between two walls, set the wall direction to whatever they face
	if is_near_wall_left && is_near_wall_right:
		wall_direction = facing
	# If we're near a left wall, wall_direction will be -(1)+(0), right wall will be -(0)+(1), neither is 0
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)

func _check_is_valid_wall(raycast):
	if raycast.is_colliding():
		# Check if we're on a slope
		var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
		# If the slope is 60 degrees either way (flipping direction changes the angle, so we need two checks)
		if dot > PI * 0.35 && dot < PI * 0.55:
			return true
	return false

# Signals
#=================================#
func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false

func _on_CoyoteTimer_timeout():
	canCoyoteJump = false
