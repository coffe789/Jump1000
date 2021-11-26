extends PlayerState
var ledge_behaviour

func enter(_arg):
	pass

func do_state_transition():
	pass

func do_state_logic(delta):
	check_if_finish_jump()
	ledge_behaviour = get_ledge_behaviour()
	if ledge_behaviour == Globals.LEDGE_REST:
		Player.velocity.y = 0
	else:
		do_gravity(delta, MAX_FALL_SPEED * WALL_GRAVITY_FACTOR, GRAVITY)
		do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
		Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_cape_acceleration():
	Player.Cape.accel = Vector2(0, 8)

func check_for_new_state() -> String:
	_update_wall_direction()
	if (Player.is_on_floor()):
		return "idle"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "walljumping"
#	if Player.wall_direction == get_input_direction() && Player.wall_direction != 0:
#		return "wallsliding"
	if ledge_behaviour == Globals.LEDGE_EXIT:
		return "falling"
	else:
		return "ledgeclinging"

