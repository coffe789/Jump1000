# Places a random tile from a horizontal 1*X autotiled TileMap
# Index zero is not used
extends TileMap
class_name VariedTileMap

export var variations = 3 # X length of autotile region. Not including index zero
var random_tiles = PoolVector2Array()

func _ready():
	set_random_tiles()
	for cell in get_used_cells():
		set_cell(cell.x ,cell.y, get_cellv(cell), 0,0,0, get_random_tile(cell.x,cell.y))
	on_ready()

func on_ready():
	pass

func set_random_tiles():
	for i in range(1,variations+1):
		random_tiles.append(Vector2(i,0))

func get_random_tile(x:int,y:int):
	seed((x << 10) + y)
	return random_tiles[randi()%(variations)]
