tool
extends TileSet
const ALL = -2

var binds = {
	-1 : [],		# Air
	0 : [],		# Nothing
	1 : [],		# Mud
	2 : [1],	# Verti wood 
	3 : [1,4],	# Tree wood
	4 : [1],	# Stone
	5 : [],		# Brick
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		if ALL in binds[drawn_id] && neighbor_id != TileMap.INVALID_CELL: # ALL means binds with everything
			return true
		else:
			return neighbor_id in binds[drawn_id]
	return false
