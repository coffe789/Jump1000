extends PlayerState
const HURT_TIME = 0.3

func enter(_init_args):
	Player.velocity.x = set_if_lesser(Player.velocity.x, -Player.facing * 130)
	Player.velocity.y = -100
	Timers.get_node("HurtStateTimer").start(HURT_TIME)

func do_state_logic(delta):
	do_attack()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK * WALLJUMP_SLOWDOWN_MULTIPLIER)
	Player.velocity = Player.move_and_slide(Player.velocity, UP_DIRECTION)

func check_for_new_state() -> String:
	if Timers.get_node("HurtStateTimer").time_left == 0:
		return Player.PS_FALLING
	else:
		return Player.PS_HURT
