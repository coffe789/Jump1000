extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func do_state_logic(_delta):
	check_buffered_jump_input()
	Player.velocity.y = 0
	apply_directional_input()
	Player.acceleration.y = GRAVITY
	apply_drag()
	clamp_movement()
	Player.velocity += Player.acceleration
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "jumping"
	if (!Player.is_on_floor()):
		return "falling"
	if (!Input.is_action_pressed("left") && !Input.is_action_pressed("right")):
		return "idle"
	return "running"
