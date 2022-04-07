tool
extends KinematicBody2D
enum Directions{
	U,D,R,L,
	UL,UR,DR,DL
}
enum { # Matches the tileset IDs
	STUMP,
	PLATFORM
}

export var width = 4 setget set_width
export(Directions) var dir = Directions.U setget set_direction
var velocity=Vector2(0,0)
var next = Vector2(10,-240)

func _ready():
	if !Engine.editor_hint:
		$SM.target = self

func _physics_process(delta):
	if !Engine.editor_hint:
		$SM.update(delta)

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
	$OneWayBody/PlatformTile.set_cell(0,0,STUMP)
	$OneWayBody/PlatformTile.set_cell(width-1,0,STUMP)
	$StumpTile.update_bitmask_region()
	$OneWayBody/PlatformTile.update_bitmask_region()
	
	# Place arrows on tiles
	$Arrow2.position.x = width * 12 - 6

func set_direction(value):
	if !Engine.editor_hint:
		yield(self,"ready")
	dir = value
	$Arrow1.frame = dir
	$Arrow2.frame = dir

func collide_with(_normal,collider):
	if collider.is_in_group("player"):
		$SM.current_state._collide()
