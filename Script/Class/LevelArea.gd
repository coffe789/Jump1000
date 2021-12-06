extends Node2D
class_name LevelArea

onready var Player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	pass

func initialise_rooms():
	for room in get_tree().get_nodes_in_group("room"):
		room.cutout_shapes()
		for overlapping_body in room.get_overlapping_bodies():
			if overlapping_body.is_in_group("room_boundary"):
				var pos_dif = room.global_position - overlapping_body.global_position #clip operation requires polygons to be in same coordiante space
				var transformed_cutout_shape = PoolVector2Array([Vector2(),Vector2(),Vector2(),Vector2()]) #this is how you create a size 4 array in gdscript
				for i in range(0,4):
					transformed_cutout_shape[i] = room.cutout_shape[i] + pos_dif
				var new_poly = Geometry.clip_polygons_2d(overlapping_body.get_node("CollisionPolygon2D").polygon, transformed_cutout_shape)
				overlapping_body.get_node("CollisionPolygon2D").polygon = new_poly[0]
				if new_poly.size() > 1: #If polygon is split into 2+ pieces, create new static bodies
					for i in range(1,new_poly.size()):
						var bound = overlapping_body.get_parent().add_boundary(new_poly[i])
						var diff = bound.global_position - overlapping_body.global_position
						for j in range(0,bound.get_child(0).polygon.size()): #clip operation only gets new shape, not position, so we set it ourselves
							bound.get_child(0).polygon[j]-=diff
	for node in get_tree().get_nodes_in_group("room_boundary"): #All bounds are disabled by default. We wait until now to disable them so clipping works
		if node is StaticBody2D:
			node.get_child(0).call_deferred("set_disabled",true)
	if Player.current_room:
		Player.current_room.enable_bounds(true)
