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

func _physics_process(_delta):
	var pos1 = position
	move_and_slide(Vector2(0,0))
	position = pos1
	for i in get_slide_count():
		var collision = get_slide_collision(i)
#	var touching = move_and_collide(Vector2.ZERO)
#	if touching:
#		print(touching.collider.name)

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
		print("omg player I'm your biggest fan")
