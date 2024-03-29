extends State

func _choose_substate():
	return $AirState


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
const JUMP_SPEED = 220
const MAX_FALL_SPEED = 200
const UP_DIRECTION = Vector2(0,-1)
const JUMP_BUFFER_DURATION = 0.13
const COYOTE_TIME = 0.09
const AFTER_JUMP_SLOWDOWN_FACTOR = 2
const WALL_GRAVITY_FACTOR = 0.1
const WALLJUMP_X_SPEED_MULTIPLIER = 1.35
const WALLJUMP_SLOWDOWN_MULTIPLIER = 0.233
const NORMAL_COLLISION_EXTENT = Vector2(3.5,8)
const DUCKING_COLLISION_EXTENT = Vector2(3.5,4)
const NORMAL_ATTACK_SIZE = Vector2(15,5)
const TWIRL_ATTACK_SIZE = Vector2(20,5)
const DASH_ATTACK_SIZE = Vector2(5,20)
const ATTACK_TIME = 0.2
const BETWEEN_ATTACK_TIME = 0.4
const TWIRL_TIME = 0.3
const WALLBOUNCE_MULTIPLIER = 1.35

const NO_DASH_TIME = 0.3
const DASH_TIME = 0.2
const ROLL_TIME = 100
const BUFFERED_DASH_TIME = 0.1

const INVINCIBLE_TIME = 2.5

#=============================================#

# Variables
#===============================================#
var state_damage_properties = [Globals.Dmg_properties.FROM_PLAYER]
var default_animation := "idle"

# TODO check which functions aren't used and delete them

#Shared utility functions
#===============================================#


func take_damage_logic(amount, properties, _damage_source):
	if !Target.is_invincible:
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
	Target.get_node("CollisionChecks/HurtBox").do_iframes()
	Target.Timers.get_node("IFrameTimer").play("invincible")


const DASH_DIR_UP = -1
const DASH_DIR_DOWN = 1
const DASH_DIR_NONE = 0
# Find closest node within dash hitboxes & set Target.dash_target_node
func set_dash_target():
	if Target.get_node("Timers/NoDashTimer").time_left != 0:
		unset_dash_target()
		return

	var best_area = null
	var best_distance = INF
	for area in Target.Dash_Check.area_list:
		if (is_instance_valid(area)
			&& (Target.position.x - area.position.x) < best_distance
			&& not (area.down_disabled && get_dash_direction(area) == DASH_DIR_DOWN)
			&& not (area.up_disabled && get_dash_direction(area) == DASH_DIR_UP)):
				best_distance = area.position.x
				best_area = area
	if Target.dash_target_node != best_area:
		Globals.emit_signal("new_dash_target", best_area)
		Target.dash_target_node = best_area

func unset_dash_target():
	Globals.emit_signal("new_dash_target", null)
	Target.dash_target_node = null

func get_dash_direction(dash_target):
	if !is_instance_valid(dash_target):
		return DASH_DIR_NONE

	var relative_position = (
		Target.global_position.y 
		- PLAYER_HEIGHT/2 
		- dash_target.global_position.y)
	if relative_position < 0:
		return DASH_DIR_DOWN
	else:
		return DASH_DIR_UP

# Set dash direction based on position of Target.dash_target_node
func set_dash_direction():
	Target.dash_direction = get_dash_direction(Target.dash_target_node)


func set_attack_hitbox():
	if !SM.is_twirling:
		Target.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
		Target.attack_box_x_distance = 11
	else:
		Target.Attack_Box.get_child(0).get_shape().extents = TWIRL_ATTACK_SIZE
		Target.attack_box_x_distance = 0
	if SM.is_ducking:
		Target.Attack_Box.position.y = -5
	else:
		Target.Attack_Box.position.y = -8

enum AttackType {NORMAL, TWIRL, DASH}
# Performs attack if button is pressed/is buffered. Returns success status
func do_attack():
	if ((Input.is_action_just_pressed("attack") && Input.is_action_pressed("ui_up"))
	or (Target.Timers.get_node("BufferedTwirlTimer").time_left > 0)) && Target.Timers.get_node("BetweenAttackTimer").time_left == 0:
		SM.is_twirling = true
		Target.Timers.get_node("TwirlTimer").start(TWIRL_TIME)
		force_attack(AttackType.TWIRL)
		return true
	elif (Input.is_action_just_pressed("attack")
	or (Target.Timers.get_node("BufferedAttackTimer").time_left > 0)) && Target.Timers.get_node("BetweenAttackTimer").time_left == 0:
		if Target.dash_direction == 0 || Target.is_on_floor():
			force_attack(AttackType.NORMAL)
			return true
	return false


# Target attacks regardless of input or whatever
func force_attack(type):
	set_attack_hitbox()
	SM.is_spinning = false
	SM.is_attacking = true
	Target.Attack_Box.damage_properties = get_damage_properties()
	Target.Attack_Box.get_child(0).disabled = false
	
	var attack_timer = Target.Timers.get_node("AttackLengthTimer")
	match (type):
		AttackType.NORMAL:
			attack_timer.start(ATTACK_TIME)
		AttackType.TWIRL:
			attack_timer.start(TWIRL_TIME)
		AttackType.DASH:
			attack_timer.start(0.2)
		
	Target.Timers.get_node("BetweenAttackTimer").start(BETWEEN_ATTACK_TIME)
	Target.Timers.get_node("BufferedAttackTimer").stop()

	match (type):
		AttackType.NORMAL:
			Target.Animation_Player.play("attack")
		AttackType.TWIRL:
			Target.Animation_Player.play("spinning")
		AttackType.DASH:
			pass
	
	yield(attack_timer, "timeout")
	Target.Animation_Player.play(SM.current_state.default_animation)

func get_damage_properties():
	var to_return = [Globals.Dmg_properties.FROM_PLAYER]
	if SM.is_dashing:
		if Target.dash_direction == -1:
			to_return.append(Globals.Dmg_properties.DASH_ATTACK_UP)
		elif Target.dash_direction == +1:
			to_return.append(Globals.Dmg_properties.DASH_ATTACK_DOWN)
	elif SM.is_twirling:
		to_return.append(Globals.Dmg_properties.PLAYER_TWIRL)
	else:
		to_return.append(Globals.Dmg_properties.PLAYER_THRUST)
	return to_return


# If for whatever reason you want to cancel an attack (like entering another state)
func stop_attack():
	Target.Attack_Box.get_child(0).set_deferred("disabled", true)
	SM.is_attacking = false
	SM.is_twirling = false
	Target.Animation_Player.play(SM.current_state.default_animation)


# What the player does after attacking (dependent on target)
func attack_response(response_id, attackable):
	match response_id:
		Globals.NORMAL_STAGGER:
			Target.velocity.x = -Target.facing * 100 # recoil
		Globals.NO_RESPONSE:
			pass
		Globals.DASH_BONK:
			Target.velocity = Vector2(-Target.facing * 170, -150)
			Target.get_node("SM").change_state(Target.get_node("SM/RootState"))
			stop_attack()
		Globals.DASH_BONK_MINI:
			Target.velocity = Vector2(-Target.facing * 130, -150)
			Target.get_node("SM").change_state(Target.get_node("SM/RootState"))
			stop_attack()
			
		


func set_attack_direction():
	Target.Attack_Box.position.x = Target.attack_box_x_distance * Target.facing
	Target.Dash_Check.position.x = 18 * Target.facing
	Target.Dash_Check.scale.x = -Target.facing


func set_ledge_ray_direction():
	Target.ledge_cast_bottom.scale.x = -Target.facing
	Target.ledge_cast_mid.scale.x = -Target.facing
	Target.ledge_cast_top.scale.x = -Target.facing
	Target.ledge_cast_lenient.scale.x = -Target.facing
	Target.ledge_cast_height_search.position.x = Target.facing * 10.5
	
	Target.left_wall_raycast.scale.x = -Target.facing
	Target.right_wall_raycast.scale.x = -Target.facing
	Target.left_wall_raycast2.scale.x = -Target.facing
	Target.right_wall_raycast2.scale.x = -Target.facing


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

# Move and slide wrapper
func apply_velocity(fix_collision=false):
	if !fix_collision:
		Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
	else:
		# Manually disable collision bug when jumping toward ledge when against it
		var Y_before = Target.velocity.y
		Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
		if Target.velocity.y == 0:
			for i in Target.get_slide_count():
				if Target.get_slide_collision(i).normal == Vector2(0,-1):
					Target.velocity.y = Y_before


func do_normal_x_movement(delta, friction_constant, walk_acceleration):
	if (abs(Target.velocity.x)>MAX_X_SPEED && sign(Target.velocity.x) == get_input_direction()): #going too fast
		Target.velocity.x = approach(Target.velocity.x, get_input_direction() * MAX_X_SPEED, delta * friction_constant * 1000 / 1.5 /1.5/1.5)
	elif (get_input_direction()!=0 && walk_acceleration > 0): # move player
		Target.velocity.x = approach(Target.velocity.x, get_input_direction() * MAX_X_SPEED, delta * walk_acceleration)
	else:	#normal friction
		Target.velocity.x = approach(Target.velocity.x, 0, delta * friction_constant * 1000)


func do_gravity(delta, max_fall_speed, fall_acceleration):
	Target.velocity.y = approach(Target.velocity.y, max_fall_speed, delta * fall_acceleration)


# Used for boosting off moving platforms
func record_floor_velocity():
	var col = Target.move_and_collide(Vector2(0,2),true,true,true)
	var vel = Vector2(0,0)
	if col:
		vel = col.collider_velocity
	if vel != Vector2(0,0) && col.normal.y < 0:
		SM.last_ground_velocity = vel
		Target.get_node("Timers/BoostTimer").start(0.3)

# Used for boosting off moving platforms
func record_wall_velocity(dir):
	var col = Target.move_and_collide(Vector2(dir*4,0),true,true,true)
	var vel = Vector2(0,0)
	if col:
		vel = col.collider_velocity
	if vel != Vector2(0,0) && col.normal.y == 0 && vel.y < 0:
		SM.last_wall_velocity.x = vel.x
		SM.last_wall_velocity.y = vel.y * 0.35
		Target.get_node("Timers/BoostTimer").start(0.3)

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
	Target.Cape.accel = Vector2(-Target.facing * 2, 8)


func set_player_sprite_direction():
	if Target.facing == 1:
		Target.Player_Sprite.flip_h = false
		Target.Player_Sprite.position.x = 0
	elif Target.facing == -1:
		Target.Player_Sprite.flip_h = true
		Target.Player_Sprite.position.x = 1
	Target.get_node("Yoyo").scale.x = Target.facing


func can_wall_jump():
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
				Target.wall_direction = 1 * Target.facing
			else:
				Target.wall_direction = -1 * Target.facing
		else:
			Target.wall_direction = Target.facing
	# If we're near a left wall, wall_direction will be -(1)+(0), right wall will be -(0)+(1), neither is 0
	else:
		Target.wall_direction = -int(is_near_wall_left||is_near_wall_left2) + int(is_near_wall_right||is_near_wall_right2)
		Target.wall_direction *= -Target.facing
	if Target.wall_direction != 0:
		Target.last_wall_direction = Target.wall_direction


func _check_is_valid_wall(raycast):
	if raycast.is_colliding():
		var object = raycast.get_collider()
		if object is PhysicsBody2D or object is PaddedTileMap or object is TileProxy:
			# Check if we're on a slope
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			# If the slope is 60 degrees either way (flipping direction changes the angle, so we need two checks)
			if dot > PI * 0.35 && dot < PI * 0.55:
				return true
	return false


#TODO test if I still even need this timer
func get_ledge_behaviour():
	if Target.facing == Target.wall_direction:
		if _check_is_valid_wall(Target.ledge_cast_mid) \
		and !_check_is_valid_wall(Target.ledge_cast_top):
			return Globals.LEDGE_REST
		elif (_check_is_valid_wall(Target.ledge_cast_bottom) || _check_is_valid_wall(Target.ledge_cast_mid)) && !_check_is_valid_wall(Target.ledge_cast_top):
			return Globals.LEDGE_NO_ACTION
		elif(_check_is_valid_wall(Target.ledge_cast_top) && !_check_is_valid_wall(Target.ledge_cast_lenient)
		and Target.velocity.y >= -10):
			return Globals.LEDGE_LENIENCY_RISE
	return Globals.LEDGE_EXIT


# Sets position and extents of player physics and hitbox collision
func set_y_collision(extents,y_position):
	Target.Collision_Body.get_shape().extents = extents
	Target.Collision_Body.position.y = y_position
	Target.get_node("CollisionChecks/HurtBox/CollisionBody").get_shape().extents = extents
	Target.get_node("CollisionChecks/HurtBox").position.y = y_position

func report_collision():
	for i in Target.get_slide_count():
		var collision = Target.get_slide_collision(i)
		if collision.get_collider() && collision.normal == Vector2(0,-1) && collision.get_collider().has_method("collide_with"):
			collision.get_collider().collide_with(collision.normal,Target)


# Buffered inputs
#==================================================================#
# Calls the others. Contents will differ per state
func _check_buffered_inputs():
	check_buffered_jump_input()
	check_buffered_attack_input()


func check_buffered_attack_input():
	if (Input.is_action_just_pressed("attack") && Input.is_action_pressed("ui_up")):
		Target.Timers.get_node("BufferedTwirlTimer").start(0.2)
	elif (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedAttackTimer").start(0.2)


func check_buffered_jump_input():
	if Input.is_action_just_pressed("jump"):
		Target.isJumpBuffered = true;
		Target.Timers.get_node("BufferedJumpTimer").start(JUMP_BUFFER_DURATION)


# Used if you want to quickly dash again while in a dash state
func check_buffered_redash_input():
	if (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedRedashTimer").start(0.15)


func check_buffered_dash_input():
	if (Input.is_action_just_pressed("attack")):
		Target.Timers.get_node("BufferedDashTimer").start(BUFFERED_DASH_TIME)

#==================================================================#
