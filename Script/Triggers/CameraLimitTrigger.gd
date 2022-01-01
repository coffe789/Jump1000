tool
extends Trigger

enum Limit_dirs{
	LEFT_LIMIT,
	RIGHT_LIMIT,
	ABOVE_LIMIT,
	BELOW_LIMIT
}

export var unset_on_leave = true
export (Limit_dirs) var limit_direction = Limit_dirs.LEFT_LIMIT

var limit_pos # Position of axis. Whether is X/Y axis depends on direction
var old_limit_pos

func on_ready():
	set_limit_pos()


func on_enter():
	pass


func activate():
	Globals.emit_signal("set_cam_limit",limit_direction,limit_pos)
	print("active")


func on_leave():
	if Globals.get_cam() && unset_on_leave:
		get_old_limit()
		Globals.emit_signal("set_cam_limit",limit_direction,old_limit_pos)


func get_old_limit():
	if Globals.get_player().current_room:
		var room = Globals.get_player().current_room
		match limit_direction:
			Limit_dirs.LEFT_LIMIT:
				old_limit_pos = room.right_x + room.global_position.x
			Limit_dirs.RIGHT_LIMIT:
				old_limit_pos = room.left_x + room.global_position.x
			Limit_dirs.ABOVE_LIMIT:
				old_limit_pos = room.bottom_y + room.global_position.y
			Limit_dirs.BELOW_LIMIT:
				old_limit_pos = room.top_y + room.global_position.y


func set_limit_pos():
	match limit_direction:
		Limit_dirs.LEFT_LIMIT:
			limit_pos = right_bound
		Limit_dirs.RIGHT_LIMIT:
			limit_pos = left_bound
		Limit_dirs.ABOVE_LIMIT:
			limit_pos = bottom_bound
		Limit_dirs.BELOW_LIMIT:
			limit_pos = top_bound
