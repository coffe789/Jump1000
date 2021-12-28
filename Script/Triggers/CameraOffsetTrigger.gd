tool
extends Trigger

export var ignoreX = false
export var ignoreY = false

export var offset_from = Vector2()
export var offset_to = Vector2()

func activate():
	set_position_ratio()
	var offset = lerp_from_position(offset_from, offset_to)
	Globals.emit_signal("set_camera_offset", offset, Vector2(ignoreX, ignoreY))
