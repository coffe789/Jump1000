tool
extends TileSet

var binds = {
	-1 : [],		# Air
	0 : [],		# Stone
	1 : [],		# stoneB
	2 : [],		# tree wood
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
