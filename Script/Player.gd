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
onready var Dash_Check = get_node("CollisionChecks/DashCheck")

export var velocity = Vector2(0,0);
var facing = 1 # Either -1 or 1
var current_room
onready var current_area = get_tree().get_nodes_in_group("area").pop_front()
var previous_position
var previous_velocity
var spawn_point
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
var dash_direction = 0
var dash_target_node = null


func _ready():
	yield(get_tree(), "idle_frame") # Wait for camera to instance
	Globals.emit_signal("player_connect_cam", self)
	
	$SM.target = self


# Controls every aspect of player physics
func _physics_process(delta) -> void:
	previous_position = position
	
	if Input.is_action_just_pressed("clear_console"):
		Globals.clear_console()
	if Input.is_action_just_pressed("ui_cancel"):
		current_room.reset_room()
	
	Cape.update_cape(delta)
	
	previous_velocity = velocity
	if $SM.target:
		$SM.update(delta)
		if velocity.x == 0 and previous_velocity.x != 0 and $SM.current_state.get_input_direction() == sign(previous_velocity.x) && !is_on_floor():
			velocity.x = previous_velocity.x * 0.95 # Retain a bit of velocity after hitting a wall
#	$DebugLabel.text = $SM.current_state.name
	return


# triggered by signal sent from attackable
# response is dependent on the attackable's id & the player's state
func attack_response(response_id, attackable):
	$SM.current_state.attack_response(response_id, attackable)


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

func reparent(new_parent):
	if new_parent:
		var poso = global_position
		get_parent().remove_child(self)
		new_parent.add_child(self)
		global_position = poso
		Globals.emit_signal("player_connect_cam",self)

# Signals
#=================================#
func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false


func _on_CoyoteTimer_timeout():
	canCoyoteJump = false


var crouch_body_count = 0
func _on_FullBody_body_area_entered(detected):
	if detected is PhysicsBody2D || detected is TileMap || detected is TileProxy:
		can_unduck = false
		crouch_body_count += 1
	elif detected.is_in_group("room") and current_area:
		current_area.do_room_transition(detected)


func _on_FullBody_body_area_exited(detected):
	if detected is PhysicsBody2D || detected is TileMap || detected is TileProxy:
		crouch_body_count -= 1
		if crouch_body_count == 0:
			can_unduck = true


func _on_HurtBox_damage_received(amount, properties, damage_source):
	$SM.current_state.take_damage_logic(amount, properties, damage_source)

