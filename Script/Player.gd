extends KinematicBody2D

export var velocity = Vector2(0,0);
var directionX = 0; #Direction player is currently moving
var directionY = 0;
var facing = 1 #either -1 or 1
var current_state = PS_FALLING
var previous_state = PS_FALLING
var current_room
var previous_position

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

var init_pos
func _init():
	init_pos = position

func _ready():
	var old_pos = position
	yield(get_tree(), "idle_frame")
	call_deferred("do_rooms")
	collision_mask = collision_mask | 16 #enable room boundary collision after boundaries are created

func do_rooms():
	for room in get_tree().get_nodes_in_group("room"):
		for overlapping_body in room.get_overlapping_bodies():
			if overlapping_body.is_in_group("room_boundary"):
				var pos_dif = room.global_position - overlapping_body.global_position
				var new_cutout_shape = PoolVector2Array([room.cutout_shape[0]+pos_dif,room.cutout_shape[1]+pos_dif,room.cutout_shape[2]+pos_dif,room.cutout_shape[3]+pos_dif])
				var new_poly = Geometry.clip_polygons_2d(overlapping_body.get_node("CollisionPolygon2D").polygon, new_cutout_shape)
				overlapping_body.get_node("CollisionPolygon2D").polygon = new_poly[0]
				if new_poly.size() > 1: #If polygon is split into 2+ pieces, create new static bodies
					for i in range(1,new_poly.size()):
						room.add_boundary(new_poly[i])

enum \
{
	PS_PREVIOUS,
	PS_JUMPING,
	PS_IDLE,
	PS_RUNNING,
	PS_FALLING,
	PS_WALLJUMPING,
	PS_WALLSLIDING,
	PS_DUCKING,
	PS_DUCKJUMPING,
	PS_DUCKFALLING,
	PS_DASHING_UP,
	PS_DASHING_DOWN,
	PS_ROLLING,
	PS_WALLBOUNCE_SLIDING,
	PS_WALLBOUNCING,
	PS_LEDGECLINGING
}

onready var state_list = \
{
	PS_PREVIOUS : "",
	PS_JUMPING : $StateMachine/jumping,
	PS_IDLE : 	$StateMachine/idle,
	PS_RUNNING : $StateMachine/running,
	PS_FALLING : $StateMachine/falling,
	PS_WALLJUMPING : $StateMachine/walljumping,
	PS_WALLSLIDING : $StateMachine/wallsliding,
	PS_DUCKING : $StateMachine/ducking,
	PS_DUCKJUMPING : $StateMachine/duckjumping,
	PS_DUCKFALLING : $StateMachine/duckfalling,
	PS_DASHING_UP : $StateMachine/dashing_up,
	PS_DASHING_DOWN : $StateMachine/dashing_down,
	PS_ROLLING : $StateMachine/rolling,
	PS_WALLBOUNCE_SLIDING : $StateMachine/wallbounce_sliding,
	PS_WALLBOUNCING : $StateMachine/wallbouncing,
	PS_LEDGECLINGING : $StateMachine/ledgeclinging
}

# Controls every aspect of player physics
func _physics_process(delta) -> void:
	previous_position = position
	if Input.is_action_just_pressed("clear_console"):
		Globals.clear_console()
	state_list[current_state].set_facing_direction()
	directionX = sign(velocity.x)
	directionY = -sign(velocity.y)
	execute_state(delta)
	try_state_transition()
	$DebugLabel.text = "State: " + str(state_list[current_state].name) + "\nPrevious:" + str(state_list[previous_state].name)

# Changes state if the current state wants to
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	if next_state == PS_PREVIOUS:
		#previous_state = current_state
		state_list[current_state].exit() #exit but don't enter
		current_state = previous_state
		execute_upon_transition()
	elif next_state != current_state:
		previous_state = current_state
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

func _on_UncrouchCheck_body_exited(body):
	if body is StaticBody2D || body is RigidBody2D:
		crouch_body_count -= 1
		if crouch_body_count ==0:
			can_unduck = true

func _on_BetweenAttackTimer_timeout():
	is_attacking = false
	get_node("CollisionChecks/AttackBox/CollisionShape2D").disabled = true

func _on_room_entered():
	print("entered room")

func _on_RoomDetection_area_entered(area):
	if area.is_in_group("room"):
		$PlayerCamera.do_room_transition(area)

