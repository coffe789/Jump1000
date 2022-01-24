extends VariedTileMap

export var direction = 0 #0up,1left,2down,3right

func on_ready():
	for cell in get_used_cells():
		get_node("Outline").set_cell(cell.x ,cell.y, 0, 0,0,0, get_cell_autotile_coord(cell.x,cell.y))
