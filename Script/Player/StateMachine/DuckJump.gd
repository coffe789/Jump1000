extends "res://Script/Player/StateMachine/JumpState.gd"

#TODO remove these and do something neater shared by duck states
func set_attack_ducking():
	Target.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -5
	Target.attack_box_x_distance = 11
func set_attack_normal():
	Target.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -8
	Target.attack_box_x_distance = 11

func _enter():
	get_parent()._enter()
	Target.velocity.y = -JUMP_SPEED
	
	Target.is_ducking = true
	set_attack_ducking()
	set_y_collision(DUCKING_COLLISION_EXTENT,-4)
	if !Target.is_ducking:
		Target.Animation_Player.play("ducking")
	else:
		Target.Animation_Player.play("ducking")

func _update(delta):
	get_parent()._update(delta)
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)

func _exit():
	Target.is_ducking = false
	set_attack_normal()
	set_y_collision(DUCKING_COLLISION_EXTENT,-4)
