extends KinematicBody2D

export var velocity = Vector2(0,0);
var directionX = 0 # Direction player is currently moving
var directionY = 0
var facing = 1 # Either -1 or 1
var current_state = PS_FALLING
var previous_state = PS_FALLING
var current_room
onready var current_area = get_tree().get_nodes_in_group("area").pop_front()
var previous_position
var spawn_point


var max_health = 2
var health = 2
export var is_invincible = false


var isJumpBuffered = false;
var canCoyoteJump = false;
var stop_jump_rise = true

onready var Cape = get_node("VerletArea")
var wall_direction = 0 # Walljump detection
var last_wall_direction = 1 # Last value that wasn't zero
var can_unduck = true
var attack_box_x_distance = 14
var is_attacking = false
var dash_direction = 0
var dash_target_node = null

enum {
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
	PS_LEDGECLINGING,
}

onready var state_list = {
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


func _ready():
	state_list[current_state].set_player_sprite_direction()
	
	yield(get_tree(), "idle_frame") # Wait for camera to instance
	Globals.emit_signal("player_connect_cam", self)


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
	#$DebugLabel.text = "State: " + str(state_list[current_state].name) + "\nPrevious:" + str(state_list[previous_state].name)
	$DebugLabel.text = str(health) + "hp"
	return

# Changes state if the current state wants to
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	if next_state == PS_PREVIOUS:
		state_list[current_state].exit() # exit but don't enter
		current_state = previous_state
		execute_upon_transition()
	elif next_state != current_state:
		previous_state = current_state
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state
		execute_upon_transition()


# Saves putting the same code in every single enter() function
func execute_upon_transition():
	print(state_list[current_state].name)
	state_list[previous_state].init_arg_list.clear()
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


# triggered by signal sent from attackable
# response is dependent on the attackable's id & the player's state
func attack_response(response_id, attackable):
	state_list[current_state].attack_response(response_id, attackable)


# Sets spawn point to the closest in the room
func set_spawn():
	var best_distance = INF
	var best_spawn
	for descendant in get_tree().get_nodes_in_group("spawnpoint"):
		if descendant.room == current_room:
			var distance = global_position.distance_to(descendant.global_position)
			if distance < best_distance:
				best_distance = distance
				best_spawn = descendant
		spawn_point = best_spawn
	
	if !best_spawn:
		push_warning("No spawnpoint in room: " + current_room.name)


func respawn():
	if (!is_instance_valid(spawn_point)):
		push_error("Failed to respawn in " + current_room.name)
		assert(false)
	
	Globals.emit_signal("set_camera_offset",Vector2(0,0),Vector2(0,0)) # Reset offset
	current_room.exit_room()
	spawn_point.spawn_player()
	
	print("respawn")
	queue_free()

func _exit_tree():
	Globals.emit_signal("player_freed")

# Signals
#=================================#
func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false


func _on_CoyoteTimer_timeout():
	canCoyoteJump = false


var crouch_body_count = 0
func _on_UncrouchCheck_body_entered(body):
	if body is StaticBody2D || body is RigidBody2D || body is TileMap:
		can_unduck = false
		crouch_body_count += 1


func _on_UncrouchCheck_body_exited(body):
	if body is StaticBody2D || body is RigidBody2D || body is TileMap:
		crouch_body_count -= 1
		if crouch_body_count == 0:
			can_unduck = true


func _on_BetweenAttackTimer_timeout():
	is_attacking = false
	get_node("CollisionChecks/AttackBox/CollisionShape2D").disabled = true


func _on_RoomDetection_area_entered(maybe_room):
	if maybe_room.is_in_group("room") and current_area:
		current_area.do_room_transition(maybe_room)


func _on_BodyArea_area_entered(_area):
	pass


func _on_HurtBox_damage_received(amount, properties, damage_source):
	state_list[current_state].take_damage_logic(amount, properties, damage_source)
