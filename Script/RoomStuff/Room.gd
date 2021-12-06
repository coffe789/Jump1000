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


func enter_room():
	enable_bounds(true)


func exit_room():
	enable_bounds(false)


# Sets coordinates of boundarys for if needed later
func init_boundarys():
	var room_collision_shape = get_node("CollisionShape2D")
	var room_size = room_collision_shape.shape.extents * 2
	left_x = -room_size.x / 2
	top_y = -room_size.y / 2
	right_x = left_x + room_size.x
	bottom_y = top_y + room_size.y


# Creates collision shape covering the whole room. Will be cutout later to serve as a boundary
func spawn_boundary_rectangle():
	var boundary_shape = $Boundary/CollisionPolygon2D
	boundary_shape.polygon[0] = Vector2(left_x,top_y) + Vector2(-boundary_margin_x,-extra_space_above-1)
	boundary_shape.polygon[1] = Vector2(right_x,top_y) + Vector2(boundary_margin_x,-extra_space_above-1)
	boundary_shape.polygon[2] = Vector2(right_x,bottom_y) + Vector2(boundary_margin_x,0)
	boundary_shape.polygon[3] = Vector2(left_x,bottom_y) + Vector2(-boundary_margin_x,0)


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
	new_boundary.add_to_group("room_boundary")
	add_child(new_boundary)
	return new_boundary


func enable_bounds(state:bool):
	for child in get_children():
		if child.is_in_group("room_boundary")  && child is StaticBody2D:
			child.get_child(0).call_deferred("set_disabled",!state)
			print(child.get_child(0))


func cutout_shapes():
	var new_poly = Geometry.clip_polygons_2d($Boundary/CollisionPolygon2D.polygon, cutout_shape_internal)
	$Boundary/CollisionPolygon2D.polygon = new_poly[0]
	if new_poly.size() > 1: #If polygon is split into 2+ pieces, create new static bodies
		for i in range(1,new_poly.size()):
			add_boundary(new_poly[i])
