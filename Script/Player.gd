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
	"walljumping" : $StateMachine/walljumping,
	"wallsliding" : $StateMachine/wallsliding,
	"ducking" : $StateMachine/ducking,
	"duckjumping" : $StateMachine/duckjumping,
	"duckfalling" : $StateMachine/duckfalling
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

# Signals
#=================================#
func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false

func _on_CoyoteTimer_timeout():
	canCoyoteJump = false


func _on_UncrouchCheck_body_entered(body):
	pass # Replace with function body.


func _on_UncrouchCheck_body_exited(body):
	pass # Replace with function body.
