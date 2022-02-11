extends "res://Script/Player/StateMachine/JumpState.gd"

func _enter():
	._enter()
	Target.is_spinning = true
	Target.Animation_Player.play("rolling")
	Target.velocity.y = -JUMP_SPEED
	play_jump_audio()

func _update(delta):
	._update(delta)
	set_dash_target()
	
	var Y_before = Target.velocity.y # This is recorded to hardcode fix a rare collision bug when ledgejumping
	Target.velocity = Target.move_and_slide(Target.velocity,UP_DIRECTION)
	if Target.velocity.y == 0:
		for i in Target.get_slide_count():
			if Target.get_slide_collision(i).normal == Vector2(0,-1):
				Target.velocity.y = Y_before

func _exit():
	Target.is_spinning = false
