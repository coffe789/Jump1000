extends KinematicBody2D

export var velocity = Vector2(0,0);
var directionX = 0; #Direction player is currently moving
var directionY = 0;
var facing = 1 #either -1 or 1
var current_state = "falling";

var isJumpBuffered = false;
var canCoyoteJump = false;
var stop_jump_rise = true

onready var Cape = get_node("../VerletArea")
var wall_direction = 0 #Walljump detection
var last_wall_direction = 1 #Last value that wasn't zero
var can_unduck = true
var attack_box_x_distance = 14
var is_attacking = false
var current_attack_id = 0 #used so enemies don't get hit twice by same attack
var dash_direction = 0
var dash_target_node = null
var last_attack_type = Globals.NORMAL_ATTACK


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
	"duckfalling" : $StateMachine/duckfalling,
	"dashing_up" : $StateMachine/dashing_up,
	"dashing_down" : $StateMachine/dashing_down,
	"rolling" : $StateMachine/rolling,
	"wallbounce_sliding" : $StateMachine/wallbounce_sliding,
	"wallbouncing" : $StateMachine/wallbouncing,
	"ledgeclinging" : $StateMachine/ledgeclinging
}

# Controls every aspect of player physics
func _physics_process(delta) -> void:
	state_list[current_state].set_facing_direction()
	directionX = sign(velocity.x)
	directionY = -sign(velocity.y)
	execute_state(delta)
	try_state_transition()

# Changes state if the current state wants to
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	if next_state != current_state:
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state
		execute_upon_transition()

#saves us putting the same code in every single enter() function
func execute_upon_transition():
	print(state_list[current_state].name)
	state_list[current_state].set_attack_hitbox()
	if state_list[current_state].unset_dash_target:
		dash_target_node = null

func execute_state(delta):
	state_list[current_state].do_state_logic(delta) # always state specific
	state_list[current_state].set_cape_acceleration() # everything here & below isn't state specific by default
	state_list[current_state].set_player_sprite_direction()
	state_list[current_state].set_attack_direction()
	state_list[current_state].check_buffered_inputs()
	state_list[current_state].set_ledge_ray_direction()

#triggered by signal sent from attackable
#response is dependent on the attackable's id & the player's state
func attack_response(response_id, attackable):
	state_list[current_state].attack_response(response_id, attackable)

# Signals
#=================================#
func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false

func _on_CoyoteTimer_timeout():
	canCoyoteJump = false


var crouch_body_count = 0
func _on_UncrouchCheck_body_entered(body):
	if body is StaticBody2D || body is RigidBody2D:
		can_unduck = false
		crouch_body_count += 1



func _on_UncrouchCheck_body_exited(body):#untested
	if body is StaticBody2D || body is RigidBody2D:
		crouch_body_count -= 1
		if crouch_body_count ==0:
			can_unduck = true


func _on_BetweenAttackTimer_timeout():
	is_attacking = false
	get_node("CollisionChecks/AttackBox/CollisionShape2D").disabled = true
