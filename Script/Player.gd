extends KinematicBody2D

export var velocity = Vector2(0,0);
export var acceleration = Vector2(0,0)


var current_state = "idle";

onready var state_list = \
{
	"jumping" : $StateMachine/jumping,
	"idle" : 	$StateMachine/idle,
	"running" : $StateMachine/running,
	"falling" : $StateMachine/falling
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



# Controls every aspect of player physics
func _physics_process(delta) -> void:
	do_state_logic(current_state, delta)
#	if is_on_floor():
#		acceleration.y=0
#		grounded=true
#		$CoyoteTimer.start(COYOTE_TIME)
#	elif is_on_ceiling():
#		acceleration.y=0
#	get_movement_input()
#	var justJumpBuffered = doBufferJump()
#	check_if_finish_jump(justJumpBuffered)
#	apply_drag()
#	acceleration.y += GRAVITY
#	clamp_movement()
#	velocity += acceleration
#	velocity = move_and_slide(velocity,UP_DIRECTION)




func state_transition():
	pass

func do_state_logic(state, delta):
	state_list[state]._physics_process(delta)
