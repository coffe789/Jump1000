extends PlayerState

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func do_state_logic(delta):
	apply_movement_input()
	Player.acceleration.y += GRAVITY
	apply_drag()
	clamp_movement()
	Player.velocity += Player.acceleration
	Player.velocity = Player.move_and_slide(Player.velocity,UP_DIRECTION)

func check_for_new_state() -> String:
	if (Player.is_on_floor()):
		if (get_inputs()=="left" || get_inputs()=="right"):
			return "running"
		else:
			return "idle"
	if (get_inputs()=="jump" && false): # false -> canCoyoteJump
		return "jumping"
	return "falling"
