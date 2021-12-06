extends Area2D
var Boundary = preload("res://Scene/Entities/Room/Boundary.tscn") 

var left_x
var right_x
var top_y
var bottom_y
var boundary_margin_x = 1 #(pixels)
var extra_space_above = 32
var cutout_shape = [0,0,0,0]
var cutout_shape_internal = [0,0,0,0]

func _ready():
	add_to_group("room")
	init_boundarys()
	spawn_boundary_rectangle()
	init_cutout_shape()
	#cutout_shapes()
	set_above_bounds()
	


func enter_room():
	enable_above_bounds(true)

func exit_room():
	print("exit: ",self)
	enable_above_bounds(false)

# Sets coordinates of boundarys for if needed later
func init_boundarys():
	var room_collision_shape = get_node("CollisionShape2D")
	var room_size = room_collision_shape.shape.extents*2
	left_x =  - room_size.x / 2
	top_y =  - room_size.y / 2
	right_x = left_x + room_size.x
	bottom_y = top_y + room_size.y

func clip():
	pass

# Creates collision shape covering the whole room. Will be cutout later to serve as a boundary
func spawn_boundary_rectangle():
	$Boundary/CollisionPolygon2D.polygon[0] = Vector2(left_x,top_y) + Vector2(-boundary_margin_x,-extra_space_above-1)
	$Boundary/CollisionPolygon2D.polygon[1] = Vector2(right_x,top_y) + Vector2(boundary_margin_x,-extra_space_above-1)
	$Boundary/CollisionPolygon2D.polygon[2] = Vector2(right_x,bottom_y) + Vector2(boundary_margin_x,0)
	$Boundary/CollisionPolygon2D.polygon[3] = Vector2(left_x,bottom_y) + Vector2(-boundary_margin_x,0)

# Sets cutout_shape to a PoolVector2Array with the same geometry as the room + upper margin
func init_cutout_shape():
	#external
	cutout_shape[0] = Vector2(left_x,top_y)
	cutout_shape[1] = Vector2(right_x,top_y)
	cutout_shape[2] = Vector2(right_x,bottom_y)
	cutout_shape[3] = Vector2(left_x,bottom_y)
	cutout_shape = PoolVector2Array(cutout_shape)
	
	cutout_shape_internal[0] = Vector2(left_x,top_y-extra_space_above)
	cutout_shape_internal[1] = Vector2(right_x,top_y-extra_space_above)
	cutout_shape_internal[2] = Vector2(right_x,bottom_y)
	cutout_shape_internal[3] = Vector2(left_x,bottom_y)
	cutout_shape_internal = PoolVector2Array(cutout_shape_internal)

func add_boundary(polygon):
	var new_boundary = Boundary.instance()
	new_boundary.get_node("CollisionPolygon2D").polygon = polygon
	add_child(new_boundary)
	print(self," ",new_boundary.name)
	return new_boundary

# Set position of the boundaries above the room
func set_above_bounds():
	$AboveBoundLeft.position = Vector2(left_x-1,top_y-extra_space_above/2)
	$AboveBoundRight.position = Vector2(right_x+1,top_y-extra_space_above/2)

func enable_above_bounds(state:bool):
	$AboveBoundLeft/CollisionShape2D.call_deferred("set_disabled",!state)
	$AboveBoundRight/CollisionShape2D.call_deferred("set_disabled",!state)
#	yield(get_tree(), "idle_frame")
#	print($AboveBoundRight/CollisionShape2D.disabled,!state) #test it works

func cutout_shapes():
	var new_poly = Geometry.clip_polygons_2d($Boundary/CollisionPolygon2D.polygon, cutout_shape_internal)
	$Boundary/CollisionPolygon2D.polygon = new_poly[0]
	if new_poly.size() > 1: #If polygon is split into 2+ pieces, create new static bodies
		for i in range(1,new_poly.size()):
			add_boundary(new_poly[i])