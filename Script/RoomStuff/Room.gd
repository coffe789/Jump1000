extends Area2D
var Boundary = preload("res://Scene/Entities/Room/Boundary.tscn") 


var left_x
var right_x
var top_y
var bottom_y
var margin_x = 1 #(pixels)
var margin_y = 1
var extra_space_above = 32
var cutout_shape = [0,0,0,0]
var cutout_shape_internal = [0,0,0,0]

var resetable_scene

func _ready():
	add_to_group("room")
	init_boundaries()
	spawn_boundary_rectangle()
	init_cutout_shape()
	init_killbox()
	
	set_resetable_scene()
	$ResetableNodes.queue_free()


func set_resetable_scene():
	resetable_scene = $ResetableNodes.create_scene()


func enter_room():
	enable_bounds(true)
	$KillBox/CollisionShape2D.call_deferred("set_disabled",false)
	var scene_instance = resetable_scene.instance()
	call_deferred("add_child",scene_instance)


func exit_room():
	enable_bounds(false)
	$KillBox/CollisionShape2D.call_deferred("set_disabled",true)
	$ResetableNodes.queue_free()


# Sets coordinates of boundarys for if needed later
func init_boundaries():
	var room_collision_shape = get_node("CollisionShape2D")
	var room_size = room_collision_shape.shape.extents * 2
	left_x = -room_size.x / 2
	top_y = -room_size.y / 2
	right_x = left_x + room_size.x
	bottom_y = top_y + room_size.y

const KILLBOX_HEIGHT = 10.0
func init_killbox():
	$KillBox.position.y = bottom_y + KILLBOX_HEIGHT / 2 + 3
	$KillBox/CollisionShape2D.shape.extents.x = (right_x - left_x) / 2


# Creates collision shape covering the whole room. Will be cutout later to serve as a boundary
func spawn_boundary_rectangle():
	var boundary_shape = $Boundary/CollisionPolygon2D
	boundary_shape.polygon[0] = Vector2(left_x,top_y) + Vector2(-margin_x,-extra_space_above-margin_y)
	boundary_shape.polygon[1] = Vector2(right_x,top_y) + Vector2(margin_x,-extra_space_above-margin_y)
	boundary_shape.polygon[2] = Vector2(right_x,bottom_y) + Vector2(margin_x,0)
	boundary_shape.polygon[3] = Vector2(left_x,bottom_y) + Vector2(-margin_x,0)


# Sets external cutout_shape to a PoolVector2Array with the same geometry as the room
# Sets internal cutout_shape to the same shape + upper margin
func init_cutout_shape():
	# external
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


func cutout_shapes():
	var new_poly = Geometry.clip_polygons_2d($Boundary/CollisionPolygon2D.polygon, cutout_shape_internal)
	$Boundary/CollisionPolygon2D.polygon = new_poly[0]
	if new_poly.size() > 1: # If polygon is split into 2+ pieces, create new static bodies
		for i in range(1,new_poly.size()):
			add_boundary(new_poly[i])


func _on_KillBox_body_entered(body):
	if body.is_in_group("player"):
		print("kill da player")
