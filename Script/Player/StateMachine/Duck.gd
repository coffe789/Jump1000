extends "res://Script/Player/StateMachine/GroundState.gd"


#TODO remove these and do something neater shared by duck states
func set_attack_ducking():
	Player.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Player.Attack_Box.position.y = -5
	Player.attack_box_x_distance = 11
func set_attack_normal():
	Player.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Player.Attack_Box.position.y = -8
	Player.attack_box_x_distance = 11


func _enter():
	Target.is_ducking = true
	set_attack_ducking()
	set_y_collision(DUCKING_COLLISION_EXTENT,-4)
	if !Player.is_ducking:
		Player.Animation_Player.play("ducking")
	else:
		Player.Animation_Player.play("ducking")


func _exit():
	Target.is_ducking = false
	set_attack_normal()
	set_y_collision(DUCKING_COLLISION_EXTENT,-4)


# Not inherited
func _update(delta):
	do_attack()
	start_coyote_time()
	do_gravity(delta, MAX_FALL_SPEED, GRAVITY)
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, DUCK_FLOOR_DRAG, 0)
