# Places a random tile from a horizontal 1*X autotiled TileMap
# Index zero is not used
extends TileMap
class_name VariedTileMap

var variations:int # X length of autotile region. Not including index zero
var random_tiles = PoolVector2Array()

func _ready():
	for cell in get_used_cells():
		if tile_set.tile_get_tile_mode(get_cellv(cell)) == tile_set.AUTO_TILE:
			variations = tile_set.tile_get_region(get_cellv(cell)).size.x / tile_set.autotile_get_size(get_cellv(cell)).x -1
			set_random_tiles()
			if variations != 0:
				set_cell(cell.x ,cell.y, get_cellv(cell), 0,0,0, get_random_tile(cell.x,cell.y))
	on_ready()

func on_ready():
	pass

func set_random_tiles():
	random_tiles.resize(0)
	for i in range(1,variations+1):
		random_tiles.append(Vector2(i,0))

func get_random_tile(x:int,y:int):
	seed((x << 10) + y)
	return random_tiles[randi()%(variations)]
