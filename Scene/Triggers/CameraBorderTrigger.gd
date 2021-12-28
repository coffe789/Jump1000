tool
extends Trigger

export var on_left = false
export var on_right = false
export var on_above = false
export var on_below = false
export var on_inside = false

var LimitTrigger = preload("res://Scene/Triggers/CameraLimitTrigger.tscn")

const SCREEN_WIDTH = 384.0
const SCREEN_HEIGHT = 216.0

# New camera limits when player is positioned relative to trigger
var limit_to_left
var limit_to_right
var limit_to_above
var limit_to_below

func on_ready():
	$Timer.start(0.1)


func on_enter():
	if on_inside:
		for child in get_children():
			if child is Trigger:
				child.unset_on_leave = false

func on_leave():
	if on_inside:
		for child in get_children():
			if child is Trigger:
				child.unset_on_leave = true
				if !child.is_player_inside:
					child.on_leave()

func init_subtriggers():
	var subtrig
	if on_left:
		subtrig = LimitTrigger.instance()
		subtrig.limit_direction = subtrig.Limit_dirs.LEFT_LIMIT
		subtrig.get_child(0).shape.extents = Vector2(SCREEN_WIDTH/2, col_shape.shape.extents.y)
		subtrig.position.x -= col_shape.shape.extents.x + subtrig.get_child(0).shape.extents.x
		add_child(subtrig)
	if on_right:
		subtrig = LimitTrigger.instance()
		subtrig.limit_direction = subtrig.Limit_dirs.RIGHT_LIMIT
		subtrig.get_child(0).shape.extents = Vector2(SCREEN_WIDTH/2, col_shape.shape.extents.y)
		subtrig.position.x += col_shape.shape.extents.x + subtrig.get_child(0).shape.extents.x
		add_child(subtrig)
	if on_above:
		subtrig = LimitTrigger.instance()
		subtrig.limit_direction = subtrig.Limit_dirs.ABOVE_LIMIT
		subtrig.get_child(0).shape.extents = Vector2(col_shape.shape.extents.x, SCREEN_HEIGHT/2)
		subtrig.position.y -= col_shape.shape.extents.y + subtrig.get_child(0).shape.extents.y
		add_child(subtrig)
	if on_below:
		subtrig = LimitTrigger.instance()
		subtrig.limit_direction = subtrig.Limit_dirs.BELOW_LIMIT
		subtrig.get_child(0).shape.extents = Vector2(col_shape.shape.extents.x, SCREEN_HEIGHT/2)
		subtrig.position.y += col_shape.shape.extents.y + subtrig.get_child(0).shape.extents.y
		add_child(subtrig)


func _on_Timer_timeout():
	init_subtriggers()
