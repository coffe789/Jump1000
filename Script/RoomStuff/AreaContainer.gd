extends Node2D

#func _ready():
#	#yield(get_tree().create_timer(0.001), "timeout")
#	do_rooms()
#	get_tree().get_nodes_in_group("player")[0].position = Vector2(0,0)
#
#func do_rooms():
#	for room in get_tree().get_nodes_in_group("room"):
#		print(room.get_overlapping_bodies())
#		for overlapping_body in room.get_overlapping_bodies():
#			if overlapping_body.is_in_group("room_boundary"):
#				var pos_dif = room.global_position - overlapping_body.global_position
#				var new_cutout_shape = PoolVector2Array([room.cutout_shape[0]+pos_dif,room.cutout_shape[1]+pos_dif,room.cutout_shape[2]+pos_dif,room.cutout_shape[3]+pos_dif])
#				var new_poly = Geometry.clip_polygons_2d(overlapping_body.get_node("CollisionPolygon2D").polygon, new_cutout_shape)
#				overlapping_body.get_node("CollisionPolygon2D").polygon = new_poly[0]
