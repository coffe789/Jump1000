extends TileMap
class_name PaddedTileMap

const SIZE = 12
const PAD_RANGE = 5

export var is_self_padded = false

var used_cells = get_used_cells()

var padded_coords = PoolVector2Array()
var center_coords = PoolVector2Array()


# Coordinates of padding in tileset texture
func set_padded_coords():
	padded_coords.append(Vector2(6,6))
	padded_coords.append(Vector2(7,6))
	padded_coords.append(Vector2(8,6))
	padded_coords.append(Vector2(9,6))
	
	padded_coords.append(Vector2(6,7))
	padded_coords.append(Vector2(6,8))
	padded_coords.append(Vector2(6,9))
	
	padded_coords.append(Vector2(9,7))
	padded_coords.append(Vector2(9,8))
	padded_coords.append(Vector2(9,9))
	
	padded_coords.append(Vector2(7,6))
	padded_coords.append(Vector2(8,6))


func set_center_coords():
	center_coords.append(Vector2(7,7))
	center_coords.append(Vector2(8,7))
	center_coords.append(Vector2(7,8))
	center_coords.append(Vector2(8,8))

func rand_padded(x:int,y:int):
	seed((x << 10) + y)
	var pad_count = padded_coords.size()
	return(padded_coords[randi()%pad_count])

func rand_center(x:int,y:int):
	seed((x << 10) + y)
	var pad_count = center_coords.size()
	return(center_coords[randi()%pad_count])

# Note size starts from 1, coords start from 0
func coord2index(x,y,size=SIZE):
	return x * (size) + y


# Note size starts from 1, index starts from 0
func index2coord(index,grid_size):
	var v = Vector2()
	v.x = (index - 1) % grid_size + 1
	v.y = int(floor(index - 1)) / grid_size
	return v


# Creates grid around tile and checks if there is air/non-connectable tiles in the grid
func check_for_air(x, y, tile_id, grid_range = PAD_RANGE):
	assert(grid_range % 2 != 0) # Must be odd number
	var start_x = x - grid_range / 2
	var start_y = y - grid_range / 2
	for i in range(start_x, start_x + grid_range):
		for j in range(start_y, start_y + grid_range):
			if get_cell(i,j) != tile_id && !(get_cell(i,j) in tile_set.binds[tile_id]):
				return true
	return false

func do_paddings():
	set_padded_coords()
	set_center_coords()
	for cell in get_used_cells():
		if get_cell_autotile_coord(cell.x,cell.y) == Vector2.ZERO:
			if check_for_air(cell.x, cell.y, get_cellv(cell)):
				set_cell(cell.x ,cell.y, get_cellv(cell), 0,0,0, rand_padded(cell.x,cell.y))
			else:
				set_cell(cell.x, cell.y, get_cellv(cell), 0,0,0, rand_center(cell.x,cell.y))

func _ready():
	if is_self_padded: # Otherwise a master tileset will do padding to support inter-room padding
		do_paddings()

