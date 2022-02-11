extends KinematicBody2D

onready var Audio = get_node("Audio")
onready var Timers = get_node("Timers")
onready var Player_Sprite = get_node("Sprite")
onready var Animation_Player = get_node("AnimationPlayer")
onready var Collision_Body = get_node("CollisionBody")
onready var left_wall_raycast = get_node("CollisionChecks/WallRaycasts/LeftWallRaycast")
onready var right_wall_raycast = get_node("CollisionChecks/WallRaycasts/RightWallRaycast")
onready var left_wall_raycast2 = get_node("CollisionChecks/WallRaycasts/LeftWallRaycast2")
onready var right_wall_raycast2 = get_node("CollisionChecks/WallRaycasts/RightWallRaycast2")
onready var ledge_cast_lenient = get_node("CollisionChecks/LedgeRaycasts/LedgeRayLenient")
onready var ledge_cast_top = get_node("CollisionChecks/LedgeRaycasts/LedgeRayTop")
onready var ledge_cast_mid = get_node("CollisionChecks/LedgeRaycasts/LedgeRayMid")
onready var ledge_cast_bottom = get_node("CollisionChecks/LedgeRaycasts/LedgeRayBottom")
onready var ledge_cast_height_search = get_node("CollisionChecks/LedgeRaycasts/LedgeRayHeightSearch")
onready var Attack_Box = get_node("CollisionChecks/AttackBox")
onready var Dash_Check_Up = get_node("CollisionChecks/DashCheckUp")
onready var Dash_Check_Down = get_node("CollisionChecks/DashCheckDown")

export var velocity = Vector2(0,0);
var directionX = 0 # Direction player is currently moving
var directionY = 0
var facing = 1 # Either -1 or 1
var current_state = PS_FALLING
var previous_state = PS_FALLING
var current_room
onready var current_area = get_tree().get_nodes_in_group("area").pop_front()
var previous_position
var previous_velocity
var spawn_point

var is_spinning = false #Player2
var is_ducking = false
var allow_dash_target = false



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
	PS_HURT,
}




func _ready():
#	state_list[current_state].set_player_sprite_direction() #TODO test
	yield(get_tree(), "idle_frame") # Wait for camera to instance
	Globals.emit_signal("player_connect_cam", self)
	
	$SM.target = self


# Controls every aspect of player physics
func _physics_process(delta) -> void:
	previous_position = position
	
	if Input.is_action_just_pressed("clear_console"):
		Globals.clear_console()
	directionX = sign(velocity.x)
	directionY = -sign(velocity.y)
	
	previous_velocity = velocity
#	execute_state(delta) # Physics and logic occurs here
#	try_state_transition()
	if $SM.target:
		$SM.update(delta)
		if velocity.x == 0 and previous_velocity.x != 0 and $SM.current_state.get_input_direction() == directionX && !is_on_floor():
			velocity.x = previous_velocity.x * 0.95 # Retain a bit of velocity after hitting a wall
	
	
#	$DebugLabel.text = "State: " + str(state_list[current_state].name) + "\nPrevious:" + str(state_list[previous_state].name)
#	$DebugLabel.text = str(health) + "hp"
	return




# Saves putting the same code in every single enter() function
#func execute_upon_transition():
##	print(state_list[current_state].name)
#	state_list[previous_state].init_arg_list.clear()
#	state_list[current_state].set_attack_hitbox()
#	if state_list[current_state].unset_dash_target:
#		dash_target_node = null


#func execute_state(delta):
#	state_list[current_state].do_state_logic(delta) # always state specific
#	state_list[current_state].set_cape_acceleration() # everything here & below isn't state specific by default
#	state_list[current_state].set_player_sprite_direction()
#	state_list[current_state].set_attack_direction()
#	state_list[current_state].check_buffered_inputs()
#	state_list[current_state].set_ledge_ray_direction()


# triggered by signal sent from attackable
# response is dependent on the attackable's id & the player's state
func attack_response(response_id, attackable):
	$SM.current_state.attack_response(response_id, attackable)

## Force state transition. Does not carry init args from previous state by default
#func set_state(state, init_args):
#	if state == current_state:
#		pass
#	else:
#		previous_state = current_state
#		state_list[current_state].exit()
#		current_state = state
#		state_list[current_state].enter(init_args)
#		execute_upon_transition()

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
	if body is PhysicsBody2D || body is TileMap:
		can_unduck = false
		crouch_body_count += 1


func _on_UncrouchCheck_body_exited(body):
	if body is PhysicsBody2D || body is TileMap:
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
	print(_area)


func _on_HurtBox_damage_received(amount, properties, damage_source):
	$SM.current_state.take_damage_logic(amount, properties, damage_source)
