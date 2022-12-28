extends AnimationPlayer
onready var SM : StateMachine = get_parent()

func _ready():
	pass # Replace with function body.

func conditional_play(name : String = "", custom_blend : float = -1, custom_speed : float = 1.0, from_end : bool = false):
	if (not SM.is_attacking):
		play(name, custom_blend, custom_speed, from_end)	
