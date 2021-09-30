extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func do_state_logic(_delta):
	apply_drag()
	Player.acceleration.y = GRAVITY
	clamp_movement()
	Player.velocity += Player.acceleration
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (!Player.is_on_floor()):
		return "falling"
	if (Input.is_action_pressed("left") || Input.is_action_pressed("right")):
		return "running"
	if (Input.is_action_just_pressed("jump")):
		return "jumping"
	return "idle"
