extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func enter(_init_arg):
	print(self.name)
	Player.acceleration.y -= JUMP_ACCELERATION
	play_jump_audio()

func do_state_logic(_delta):
	if (Player.is_on_ceiling()):
		Player.acceleration.y = 0
	apply_movement_input()
	Player.acceleration.y += GRAVITY
	apply_drag()
	clamp_movement()
	Player.velocity += Player.acceleration
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.velocity.y > 0):
		return "falling"
	if (Player.is_on_floor()):
		return "idle"
	return "jumping"
