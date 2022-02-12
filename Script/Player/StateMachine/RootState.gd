extends State

func _choose_substate():
	return $AirState




# Nodes of global interest
#==================================================#
var Player = Target


# Constants
#====================================================#
const DASH_SPEED_X = 180
const DASH_SPEED_Y = 150
const PLAYER_HEIGHT = 18.0
const PLAYER_WIDTH = 8
const GRAVITY = 600
const ACCELERATE_WALK = 1500/1.5
const FLOOR_DRAG = 1.5
const DUCK_FLOOR_DRAG = 0.6
const AIR_DRAG = 0.14 * 1.5
const MAX_X_SPEED = 100
const JUMP_SPEED = 238
const MAX_FALL_SPEED = 250
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.13
const COYOTE_TIME = 0.065
const AFTER_JUMP_SLOWDOWN_FACTOR = 2
const WALL_GRAVITY_FACTOR = 0.075
const WALLJUMP_X_SPEED_MULTIPLIER = 1.35
const WALLJUMP_SLOWDOWN_MULTIPLIER = 0.233
const NORMAL_COLLISION_EXTENT = Vector2(3.5,8)
const DUCKING_COLLISION_EXTENT = Vector2(3.5,4)
const NORMAL_ATTACK_SIZE = Vector2(15,5)
const DASH_ATTACK_SIZE = Vector2(5,15)
const WALLBOUNCE_MULTIPLIER = 1.35

const NO_DASH_TIME = 0.3
const DASH_TIME = 0.2
const ROLL_TIME = 0.4
const BUFFERED_DASH_TIME = 6.0/60.0

const INVINCIBLE_TIME = 2.5
# State Initialisation Parameters
#=============================================#
enum init_args {
	FROM_DUCKING,
	ENTER_ROLLING,
	ENTER_SUPER_JUMP
}

var init_arg_list = []

#=============================================#

# Variables
#===============================================#
var is_dashing = false
var unset_dash_target = true
var state_damage_properties = [Globals.Dmg_properties.FROM_PLAYER]

# TODO check which ones of these aren't used and delete them

#Shared utility functions
#===============================================#


func take_damage_logic(amount, properties, _damage_source):
	if !Target.is_invincible:
		print(Target.velocity.y)
		if properties.has(Globals.Dmg_properties.FROM_PLAYER):
			pass
		elif not (Target.previous_velocity.y < 0 and properties.has(Globals.Dmg_properties.IMMUNE_UP))\
			and not (Target.velocity.y > 0 and properties.has(Globals.Dmg_properties.IMMUNE_DOWN))\
			and not (Target.velocity.x < 0 and properties.has(Globals.Dmg_properties.IMMUNE_LEFT))\
			and not (Target.velocity.x > 0 and properties.has(Globals.Dmg_properties.IMMUNE_RIGHT)):
			Target.health -= amount
			#Animation unreliably sets invincible to true fast enough
			Target.is_invincible = true
			do_iframes()
			SM.change_state(SM.get_node("RootState/AirState/Hurt"))
			if Target.health <= 0:
				Target.is_invincible = true # Prevent respawning twice
				Target.respawn()


func heal(amount):
	if !(Target.health >= Target.max_health):
		Target.health += amount
		Target.health = clamp(Target.health, 0, Target.max_health)
		print("healed ",Target.health)


func do_iframes():
	Target.Timers.get_node("IFrameTimer").play("invincible")


const DASH_DIR_UP = -1
const DASH_DIR_DOWN = 1
const DASH_DIR_NONE = 0
# Find closest node within dash hitboxes & set Target.dash_target_node
func set_dash_target():
	var best_node = null
	var best_distance = INF
	for i in Target.Dash_Check_Up.area_list.size():
		if ((Target.position.x - Target.Dash_Check_Up.area_list[i].position.x) < best_distance):
			best_distance = Target.Dash_Check_Up.area_list[i].position.x
			best_node = Target.Dash_Check_Up.area_list[i]
	for i in Target.Dash_Check_Down.area_list.size():
		if ((Target.position.x - Target.Dash_Check_Down.area_list[i].position.x) < best_distance):
			best_distance = Target.Dash_Check_Down.area_list[i].position.x
			best_node = Target.Dash_Check_Down.area_list[i]
	Target.dash_target_node = best_node
	if best_node != null:
		Target.dash_target_node = best_node.get_parent()


# Set dash direction based on position of Target.dash_target_node
func set_dash_direction():
	if Target.dash_target_node == null:
		Target.dash_direction = DASH_DIR_NONE
		return 
	var relative_position = (
		Target.global_position.y 
		- PLAYER_HEIGHT/2 
		- Target.dash_target_node.global_position.y)
	if relative_position < 0:
		Target.dash_direction = DASH_DIR_DOWN
		return
	else:
		Target.dash_direction =  DASH_DIR_UP
		return


func set_attack_hitbox():
	Target.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -8
	Target.attack_box_x_distance = 11


# Performs attack if button is pressed/is buffered. Returns success status
func do_attack():
	if (Input.is_action_just_pressed("attack") && !Target.is_attacking)\
	or (Target.Timers.get_node("BufferedAttackTimer").time_left > 0 && !Target.is_attacking):
		if Target.dash_direction == 0:
			force_attack()
			return true
	return false


# Target attacks regardless of input or whatever
func force_attack():
	Target.Attack_Box.damage_properties = state_damage_properties
	Target.Attack_Box.get_child(0).disabled = false
	Target.is_attacking = true
	Target.Timers.get_node("BetweenAttackTimer").start(0.4)
	Target.Timers.get_node("BufferedAttackTimer").stop()


# If for whatever reason you want to cancel an attack (like entering another state)
func stop_attack():
	Target.Attack_Box.get_child(0).disabled = true
	Target.is_attacking = false


# What the player does after attacking (dependent on target)
# I think this should be deleted and I can just use a global signal?
func attack_response(response_id, attackable):
	match response_id:
		Globals.NORMAL_STAGGER:
			Target.velocity.x = -Target.facing * 100 # recoil
			attackable.on_attacked(2,Globals.NORMAL_ATTACK) #do damage or something
		Globals.NO_RESPONSE:
			pass
		Globals.DASH_BONK:
			Target.velocity = Vector2(-Target.facing * 70, -150)


func set_attack_direction():
	Target.Attack_Box.position.x = Target.attack_box_x_distance * Target.facing
	Target.Dash_Check_Up.position.x = 18 * Target.facing
	Target.Dash_Check_Down.position.x = 18 * Target.facing
	Target.Dash_Check_Down.scale.x = -Target.facing
	Target.Dash_Check_Up.scale.x = -Target.facing


func set_ledge_ray_direction():
	Target.ledge_cast_bottom.scale.x = -Target.facing
	Target.ledge_cast_mid.scale.x = -Target.facing
	Target.ledge_cast_top.scale.x = -Target.facing
	Target.ledge_cast_lenient.scale.x = -Target.facing
	Target.ledge_cast_height_search.position.x = Target.facing * 11
	
#	Target.left_wall_raycast.scale.x = -Target.facing
#	Target.right_wall_raycast.scale.x = -Target.facing
#	Target.left_wall_raycast2.scale.x = -Target.facing
#	Target.right_wall_raycast2.scale.x = -Target.facing


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
	if (abs(Target.velocity.x)>MAX_X_SPEED && Target.directionX == get_input_direction()): #going too fast
		Target.velocity.x = approach(Target.velocity.x, get_input_direction() * MAX_X_SPEED, delta * friction_constant * 1000 / 1.5 /1.5/1.5)
	elif (get_input_direction()!=0 && walk_acceleration > 0): # move player
		Target.velocity.x = approach(Target.velocity.x, get_input_direction() * MAX_X_SPEED, delta * walk_acceleration)
	else:	#normal friction
		Target.velocity.x = approach(Target.velocity.x, 0, delta * friction_constant * 1000)


func do_unconcontrolled_movement(delta, desired_speed, acceleration):
	Target.velocity.x = approach(Target.velocity.x, desired_speed, delta * acceleration)


func do_gravity(delta, max_fall_speed, fall_acceleration):
	Target.velocity.y = approach(Target.velocity.y, max_fall_speed, delta * fall_acceleration)


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


# sets value to maximum only if maximum has a greater magnitude
# Is used such that speed boosts can't slow you down
func set_if_lesser(to_set, maximum):
	if abs(to_set) > abs(maximum) && Globals.is_same_sign(to_set,maximum):
		return to_set
	return maximum


func start_coyote_time():
	Target.canCoyoteJump = true
	Target.Timers.get_node("CoyoteTimer").start(COYOTE_TIME)


# If you let go of jump, stop going up. Also handles buffered case.
func check_if_finish_jump() -> void:
	if ((!Input.is_action_pressed("jump") && !Target.stop_jump_rise)):
		Target.velocity.y /= AFTER_JUMP_SLOWDOWN_FACTOR;
		Target.stop_jump_rise = true;


#Changes facing direction if an input is pressed. Otherwise facing remains as is.
func set_facing_direction():
	if get_input_direction()==1:
		Target.facing = 1
	if get_input_direction() == -1:
		Target.facing = -1


func set_cape_acceleration():
	Target.Cape.accel = Vector2(-Target.facing * 4, 8)


func set_player_sprite_direction():
	if Target.facing == -1:
		Target.Player_Sprite.flip_h = false
		Target.Player_Sprite.position.x = 0
	elif Target.facing == 1:
		Target.Player_Sprite.flip_h = true
		Target.Player_Sprite.position.x = 1


func can_wall_jump():
	_update_wall_direction()
	# If we're near a valid wall
	if Target.wall_direction != 0:
		return true
	return false


func _update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(Target.left_wall_raycast)
	var is_near_wall_right = _check_is_valid_wall(Target.right_wall_raycast)
	var is_near_wall_left2 = _check_is_valid_wall(Target.left_wall_raycast2)
	var is_near_wall_right2 = _check_is_valid_wall(Target.right_wall_raycast2)
	
	# If the player is sandwiched between two walls, check which wall is closer
	if (is_near_wall_left || is_near_wall_left2) && (is_near_wall_right || is_near_wall_right2):
		if Target.left_wall_raycast.get_collision_point() && Target.right_wall_raycast.get_collision_point():
			var left_len = abs(Target.global_position.x - Target.left_wall_raycast.get_collision_point().x)
			var right_len = abs(Target.global_position.x - Target.right_wall_raycast.get_collision_point().x)
			if left_len > right_len:
				Target.wall_direction = 1
			else:
				Target.wall_direction = -1
		else:
			Target.wall_direction = Target.facing
	# If we're near a left wall, wall_direction will be -(1)+(0), right wall will be -(0)+(1), neither is 0
	else:
		Target.wall_direction = -int(is_near_wall_left||is_near_wall_left2) + int(is_near_wall_right||is_near_wall_right2)
	if Target.wall_direction != 0:
		Target.last_wall_direction = Target.wall_direction


func _check_is_valid_wall(raycast):
	if raycast.is_colliding():
		var object = raycast.get_collider()
		if object is PhysicsBody2D or object is PaddedTileMap:
			# Check if we're on a slope
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			# If the slope is 60 degrees either way (flipping direction changes the angle, so we need two checks)
			if dot > PI * 0.35 && dot < PI * 0.55:
				return true
	return false


#TODO test if I still even need this timer
func get_ledge_behaviour():
	_update_wall_direction()
	if get_input_direction() == Target.wall_direction && Target.wall_direction!=0 && Target.Timers.get_node("PostClingJumpTimer").time_left == 0:
		if _check_is_valid_wall(Target.ledge_cast_mid) \
		and !_check_is_valid_wall(Target.ledge_cast_top):
			return Globals.LEDGE_REST
		elif (_check_is_valid_wall(Target.ledge_cast_bottom) || _check_is_valid_wall(Target.ledge_cast_mid)) && !_check_is_valid_wall(Target.ledge_cast_top):
			return Globals.LEDGE_NO_ACTION
		elif(_check_is_valid_wall(Target.ledge_cast_top) && !_check_is_valid_wall(Target.ledge_cast_lenient) && Target.current_state!=Target.PS_WALLSLIDING)\
		and Target.velocity.y >= -10:
			return Globals.LEDGE_LENIENCY_RISE
	return Globals.LEDGE_EXIT


func emit_jump_particles(is_walljump=false):
	Target.get_node("Particles/JumpCloud").emitting = true
	Target.get_node("Particles/JumpCloud").process_material.direction.x = -Target.directionX
	if is_walljump:
		Target.get_node("Particles/JumpCloud").position.x = +4*Target.directionX
	else:
		Target.get_node("Particles/JumpCloud").position.x = -4*Target.directionX
	yield(get_tree().create_timer(0.04), "timeout")
	Target.get_node("Particles/JumpCloud").emitting = false

# Sets position and extents of player physics and hitbox collision
func set_y_collision(extents,y_position):
	Target.Collision_Body.get_shape().extents = extents
	Target.Collision_Body.position.y = y_position
	Target.get_node("CollisionChecks/HurtBox/CollisionBody").position.y = y_position

# Buffered inputs
#==================================================================#
# Calls the others. Contents will differ per state
func check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()


func check_buffered_attack_input():
	if (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedAttackTimer").start(0.2)


func check_buffered_jump_input():
	if Input.is_action_just_pressed("jump"):
		Target.isJumpBuffered = true;
		Target.Timers.get_node("BufferedJumpTimer").start(JUMP_BUFFER_DURATION)


# Used if you want to quickly dash again while in a dash state
func check_buffered_redash_input():
	if (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedRedashTimer").start(0.1)


func check_buffered_dash_input():
	if (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedDashTimer").start(BUFFERED_DASH_TIME)

#==================================================================#
