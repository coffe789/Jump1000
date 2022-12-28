extends PaddedTileMap
const TILE_SIZE = 12
export var group_to_merge = "join_tile"

func _ready():
	merge_tilesets()

func merge_tilesets():
	for tilemap in get_tree().get_nodes_in_group(group_to_merge):
		for cell in tilemap.get_used_cells():
			set_cellv(cell + tilemap.global_position / TILE_SIZE, tilemap.get_cellv(cell))
		tilemap.queue_free()
	
	update_bitmask_region()
	do_paddings()
