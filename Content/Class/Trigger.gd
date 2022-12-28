tool
extends Area2D
class_name Trigger


enum P_mode {
	NO_EFFECT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP,
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
}

enum Target_types {
	BODY,
	AREA,
}

export var target_group = "player"
export(Target_types) var target_type = Target_types.BODY
export(int, 
"no effect",
"top to bottom",
"bottom to top",
"left to right",
"right to left") var position_mode = 0

onready var col_shape = get_child(0) as CollisionShape2D

var p_mult := 1.0
var is_oneshot := false
var pos_ratio := Vector2()

var left_bound
var right_bound
var top_bound
var bottom_bound

var is_player_inside = false

func _ready():
	if !Engine.editor_hint:
		self.add_to_group("trigger")
		if target_type == Target_types.BODY:
			connect("body_entered", self, "_on_target_entered")
			connect("body_exited", self, "_on_target_exited")
		elif target_type == Target_types.AREA:
			connect("area_entered", self, "_on_target_entered")
			connect("area_exited", self, "_on_target_exited")
		set_bounds()
		on_ready()
		assert(target_group!=null)


# Used so I don't have to overwrite _ready() in inherited objects
func on_ready():
	pass


func _process(_delta):
	if !Engine.editor_hint:
		if is_player_inside:
			activate()
	else:
		update()


func _on_target_entered(target:Node):
	if target.is_in_group(target_group):
		is_player_inside = true
		on_enter()


func _on_target_exited(target:Node):
	if target.is_in_group(target_group):
		is_player_inside = false
		on_leave()


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


var font = Control.new().get_font("font")
func _draw():
	if Engine.editor_hint:
		draw_string(font, Vector2.ZERO - Vector2(get_child(0).shape.extents.x,0), name, Color(1,1,1))


func on_enter():
	pass


func activate():
	pass


func on_leave():
	pass
