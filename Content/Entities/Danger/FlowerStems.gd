extends DamageHitbox

func _ready():
	do_outlines()

func do_outlines():
	for cell in $StemTiles.get_used_cells():
		$StemOutlineTiles.set_cell(cell.x ,cell.y, $StemTiles.get_cellv(cell), 0,0,0)
