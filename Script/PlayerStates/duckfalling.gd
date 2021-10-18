extends PlayerState
var is_exit_unduck = false

func do_state_logic(delta):
	Collision_Body.get_shape().extents = DUCKING_COLLISION_EXTENT
	Collision_Body.position.y = -4
	check_buffered_jump_input()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if (Input.is_action_pressed("down") || !Player.can_unduck):
			is_exit_unduck = false
			return "ducking"
		if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
			is_exit_unduck = true
			return "running"
		else:
			is_exit_unduck = true
			return "idle"
	return "duckfalling"

func exit():
	if is_exit_unduck:
		Collision_Body.get_shape().extents = NORMAL_COLLISION_EXTENT
		Collision_Body.position.y = -8
