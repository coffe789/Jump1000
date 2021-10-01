extends KinematicBody2D

export var velocity = Vector2(0,0);
export var acceleration = Vector2(0,0)
var isJumpBuffered = false;

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
	state_list[current_state].do_state_logic(delta)
	try_state_transition()

# Changes state if the current state wants to
func try_state_transition():
	var next_state = state_list[current_state].check_for_new_state()
	if next_state != current_state:
		var init_arg = state_list[current_state].exit()
		state_list[next_state].enter(init_arg)
		current_state = next_state

func _on_BufferedJumpTimer_timeout():
	isJumpBuffered = false;
