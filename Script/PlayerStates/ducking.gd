extends PlayerState

func enter(_init_arg):
	Ducking_Collision_Body.disabled = false
	Collision_Body.disabled = true;
	Animation_Player.play("idle")
	print(self.name)

func do_state_logic(delta):
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "duckfalling"
	if (Input.is_action_just_pressed("jump") || Player.isJumpBuffered):
		return "duckjumping"
	if (!Input.is_action_pressed("down")):
		return "idle"
	return "ducking"

func exit():
	Ducking_Collision_Body.disabled = true
	Collision_Body.disabled = false
