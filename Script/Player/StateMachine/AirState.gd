extends "res://Script/Player/StateMachine/RootState.gd"

func _update(delta):
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	do_normal_x_movement(delta,AIR_DRAG, ACCELERATE_WALK)
#	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
