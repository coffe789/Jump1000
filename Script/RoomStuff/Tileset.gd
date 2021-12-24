tool
extends TileSet

var binds = {
	0 : [],		# Nothing
	1 : [],		# Mud
	2 : [1],	# Verti wood 
	3 : [1],	# Tree wood
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
