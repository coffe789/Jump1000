extends "res://Script/Player/StateMachine/AirState.gd"

# TODO get rid of the thing that used to call this every frame/transition or whatever
func set_normal_hitbox():
	Target.Attack_Box.get_child(0).get_shape().extents = NORMAL_ATTACK_SIZE
	Target.Attack_Box.position.y = -8
	Target.attack_box_x_distance = 11

func set_dash_hitbox():
	Target.Attack_Box.get_child(0).get_shape().extents = DASH_ATTACK_SIZE
	Target.Attack_Box.position.y = -8
	Target.attack_box_x_distance = 11

func _choose_substate():
	if conditions_lib.is_dash_up():
		return $DashUp
	return $DashDown


func _enter():
	set_dash_hitbox()
	SM.is_dashing = true
	force_attack()
	SM.is_twirling = false
	Target.Timers.get_node("DashTimer").start(DASH_TIME)
	Target.Timers.get_node("NoDashTimer").start(NO_DASH_TIME)
	Target.stop_jump_rise = false
	Target.isJumpBuffered = false
	Target.canCoyoteJump = false
	Target.velocity.x = set_if_lesser(Target.velocity.x, Target.facing * DASH_SPEED_X)


func _update(delta):
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
	do_normal_x_movement(delta, 0, ACCELERATE_WALK/4)


func _add_transitions():
	._add_transitions()
	transitions.append(StateTransition.new(
		-10,"dash_timeout",SM.get_node("RootState/AirState/FallState")
		,funcref(conditions_lib,"is_dash_timeout")))


func _exit():
	stop_attack()
	SM.is_dashing = false
	set_normal_hitbox()


func _check_buffered_inputs():
	._check_buffered_inputs()
	check_buffered_redash_input()


func set_player_sprite_direction():
	pass

func set_facing_direction():
	pass
