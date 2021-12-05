extends Area2D
var Boundary = preload("res://Scene/Entities/Room/Boundary.tscn")

var left_x
var right_x
var top_y
var bottom_y
var boundary_margin_x = 3 #(pixels)
var boundary_margin_up = 32
var cutout_shape = [0,0,0,0]

func _ready():
	add_to_group("room")
	init_boundarys()
	spawn_boundary_rectangle()
	init_cutout_shape()
	#cutout_shapes()
	


func enter_room():
	pass

func exit_room():
	pass

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
	$Boundary/CollisionPolygon2D.polygon[0] = Vector2(left_x,top_y) + Vector2(-boundary_margin_x,-boundary_margin_up)
	$Boundary/CollisionPolygon2D.polygon[1] = Vector2(right_x,top_y) + Vector2(boundary_margin_x,-boundary_margin_up)
	$Boundary/CollisionPolygon2D.polygon[2] = Vector2(right_x,bottom_y) + Vector2(boundary_margin_x,0)
	$Boundary/CollisionPolygon2D.polygon[3] = Vector2(left_x,bottom_y) + Vector2(-boundary_margin_x,0)

# Sets cutout_shape to a PoolVector2Array with the same geometry as the room
func init_cutout_shape():
	cutout_shape[0] = Vector2(left_x,top_y)
	cutout_shape[1] = Vector2(right_x,top_y)
	cutout_shape[2] = Vector2(right_x,bottom_y)
	cutout_shape[3] = Vector2(left_x,bottom_y)
	cutout_shape = PoolVector2Array(cutout_shape)

func add_boundary(polygon):
	var new_boundary = Boundary.instance()
	new_boundary.get_node("CollisionPolygon2D").polygon = polygon
	add_child(new_boundary)

func cutout_shapes():
	var new_poly = Geometry.clip_polygons_2d($Boundary/CollisionPolygon2D.polygon, cutout_shape)
	$Boundary/CollisionPolygon2D.polygon = new_poly[0]
