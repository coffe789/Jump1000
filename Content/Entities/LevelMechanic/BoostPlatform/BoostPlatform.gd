tool
extends KinematicBody2D
class_name BoostPlatform
onready var raycasts = [$TileMap/Arrow1/RayCast1, $TileMap/Arrow2/RayCast2]

enum Directions{
	U,D,R,L,
	UL,UR,DR,DL,
	NEUTRAL
}
enum { # Matches the tileset IDs
	STUMP,
	PLATFORM,
	INVISIBLE
}

export var width = 4 setget set_width
export(Directions) var dir setget set_direction
export var is_debug = false
var init_velocity
var init_position = position
var velocity = Vector2.ZERO

func set_init_velocity():
	init_velocity = Vector2()
	var y_axis_speed = 162
	var x_axis_speed = 60
	match dir: # vertical velocity
		Directions.U,Directions.UL,Directions.UR:
			init_velocity.y = -y_axis_speed
		Directions.D,Directions.DL,Directions.DR:
			init_velocity.y = y_axis_speed
	match dir:
		Directions.L,Directions.UL,Directions.DL:
			init_velocity.x = -x_axis_speed
		Directions.R,Directions.UR,Directions.DR:
			init_velocity.x = x_axis_speed

func _ready():
	if !Engine.editor_hint:
		$SM.target = self
		yield(self,"ready")

func _physics_process(delta):
	if !Engine.editor_hint:
		if !(is_debug && Input.is_action_pressed("down")):
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
	$TileMap.clear()
	$TileProxy/ProxyShape.clear()
	for i in range(1,width-1):
		$TileMap.set_cell(i,0,PLATFORM)
	$TileMap.set_cell(0,0,STUMP)
	$TileMap.set_cell(width-1,0,STUMP)
	$TileProxy/ProxyShape.set_cell(0,0,INVISIBLE)
	$TileProxy/ProxyShape.set_cell(width-1,0,INVISIBLE)
	$TileMap.update_bitmask_region()
	$TileProxy/ProxyShape.update_bitmask_region()
	
	# Place arrows on tiles
	$TileMap/Arrow2.position.x = width * 12 - 6
	$DustCloud2.position.x = width * 12 - 6

func a(value):
	dir = value
	set_init_velocity()
	if $TileMap/Arrow1:
		$TileMap/Arrow1.frame = dir
		$TileMap/Arrow2.frame = dir

func set_direction(value):
	if !Engine.editor_hint:
		yield(self,"ready")
	dir = value
	set_init_velocity()
	if $TileMap/Arrow1:
		$TileMap/Arrow1.frame = dir
		$TileMap/Arrow2.frame = dir

func collide_with(normal,collider):
	$SM.current_state._collide(normal, collider)

var is_respawning = false
func _on_DetectOOB_area_exited(area):
	if area is RoomArea && not is_respawning:
		yield(get_tree().create_timer(1),"timeout")
		$SM.change_state($SM/RootState/Respawn)
