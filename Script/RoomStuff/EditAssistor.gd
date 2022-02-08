tool
extends Node2D

var edi # for caching EditorInterface
var selected_room = null
var selected_extents

const SIDE_WIDTH = 10000.0
const SIDE_HEIGHT = 20000.0
const VERT_HEIGHT = 10000.0

var rec_left
var rec_top
var rec_right
var rec_bottom

export var border_width = 3
export var unfocus_color = Color(0.2,0.2,0.4,0.8)
export var active_border_color = Color(0.8,0.8,0.9,0.8)
export var inactive_border_color = Color(0.8,0.8,0.9,0.3)

func _init():
	if Engine.editor_hint:
		set_process_input(true);
		var plugin = EditorPlugin.new()
		edi = plugin.get_editor_interface()
		plugin.queue_free()


func _process(_delta):
	if Engine.editor_hint && edi.get_selection().get_selected_nodes().size() > 0:
		if edi.get_selection().get_selected_nodes()[0].is_in_group("editor_room"):
			selected_room = edi.get_selection().get_selected_nodes()[0]
		if selected_room:
			update_graphics()


func update_graphics():
	selected_extents = selected_room.get_node("CollisionShape2D").shape.extents
	set_border_rects()
	update()


func _draw():
	if Engine.editor_hint:
		if selected_room:
			draw_rect(rec_left, unfocus_color)
			draw_rect(rec_right, unfocus_color)
			draw_rect(rec_bottom, unfocus_color)
			draw_rect(rec_top, unfocus_color)
			draw_rect(extent2rect(selected_room), active_border_color, false, border_width)
		
		for room in get_tree().get_nodes_in_group("editor_room"):
			if room != selected_room:
				draw_rect(extent2rect(room), inactive_border_color, false, border_width)
				draw_rect(extent2rect(room), Color(1,1,1,0.1))

func set_border_rects():
	rec_left = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x + SIDE_WIDTH, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))
	rec_right = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(-selected_extents.x, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))
	
	rec_top = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x, selected_extents.y + VERT_HEIGHT), Vector2(selected_extents.x * 2,VERT_HEIGHT))
	rec_bottom = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x, -selected_extents.y), Vector2(selected_extents.x * 2,VERT_HEIGHT))


func extent2rect(room):
	var extent = room.get_node("CollisionShape2D").shape.extents
	return Rect2(room.get_node("CollisionShape2D").global_position-extent,extent*2)
