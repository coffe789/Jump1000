extends Area2D
class_name Trigger

enum P_mode {
	NO_EFFECT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP,
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
}

onready var col_shape = get_child(0) as CollisionShape2D

export(int, 
"no effect",
"top to bottom",
"bottom to top",
"left to right",
"right to left") var position_mode = 0

var p_mult := 1.0
var is_oneshot := false
var pos_ratio := Vector2()

var left_bound
var right_bound
var top_bound
var bottom_bound

func _ready():
	connect("body_entered", self, "_on_body_entered")
	set_bounds()


func _on_body_entered(_body:Node):
	activate()


# Set bound parameters for convenience 
func set_bounds():
	var trigger_size = col_shape.shape.extents * 2
	left_bound = global_position.x - trigger_size.x / 2
	right_bound = global_position.x + trigger_size.x / 2
	top_bound = global_position.y - trigger_size.y / 2
	bottom_bound = global_position.y + trigger_size.y /2


# Sets/checks where in the trigger the player is
func set_position_ratio():
	var player_pos = Globals.get_player().global_position
	pos_ratio.x = (player_pos.x - left_bound) / (right_bound - left_bound)
	pos_ratio.y = (player_pos.y - top_bound) / (bottom_bound - top_bound)
	
	pos_ratio.x = clamp(pos_ratio.x, 0, 1)
	pos_ratio.y = clamp(pos_ratio.y, 0, 1)


# Use the player's position within the trigger to lerp a number
func lerp_from_position(lerp_from, lerp_to):
	match position_mode:
		P_mode.NO_EFFECT:
			return lerp_to
		P_mode.LEFT_TO_RIGHT:
			return lerp(lerp_from,lerp_to, pos_ratio.x)
		P_mode.TOP_TO_BOTTOM:
			return lerp(lerp_from,lerp_to, pos_ratio.y)
		P_mode.RIGHT_TO_LEFT:
			return lerp(lerp_to,lerp_from, pos_ratio.x)
		P_mode.BOTTOM_TO_TOP:
			return lerp(lerp_to,lerp_from, pos_ratio.y)

#func _physics_process(delta):
#	set_position_ratio()
#	print(lerp_from_position(0,10))


func activate():
	pass

