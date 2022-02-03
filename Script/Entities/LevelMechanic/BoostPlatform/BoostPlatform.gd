tool
extends KinematicBody2D

export var width = 4 setget set_width

enum { # Matches the tileset IDs
	STUMP,
	PLATFORM
}

func set_width(value):
	if Engine.editor_hint:
		width = value
		place_tiles()
	else:
		width = value
		yield(self,"ready")
		place_tiles()

func place_tiles():
	$StumpTile.clear()
	$OneWayBody/PlatformTile.clear()
	for i in range(1,width-1):
		$OneWayBody/PlatformTile.set_cell(i,0,PLATFORM)
	$StumpTile.set_cell(0,0,STUMP)
	$StumpTile.set_cell(width-1,0,STUMP)
	$StumpTile.update_bitmask_region()
	$OneWayBody/PlatformTile.update_bitmask_region()
