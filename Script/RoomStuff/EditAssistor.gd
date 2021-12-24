tool
extends Node2D

var edi # for caching EditorInterface
var selected_room = null
var selected_extents

const REC_SIZE = 10
const SIDE_WIDTH = 10000
const SIDE_HEIGHT = 20000
const VERT_HEIGHT = 10000

var rec_left
var rec_top
var rec_right
var rec_bottom

func _init():
	if Engine.editor_hint:
		name = "test"
		var plugin = EditorPlugin.new()
		edi = plugin.get_editor_interface() # now you always have the interface
		plugin.queue_free()

# Then, in whatever context you want, you should be able to access it
func _process(_delta):
	if Engine.editor_hint:
		if edi.get_selection().get_selected_nodes()[0].is_in_group("editor_room"):
			if selected_room != edi.get_selection().get_selected_nodes()[0]:
				selected_room = edi.get_selection().get_selected_nodes()[0]
				selected_extents = selected_room.get_node("CollisionShape2D").shape.extents
				extent2rec()
				
				update()

func _draw():
	if selected_room != null:
		draw_rect(rec_left,Color(0.2,0.2,0.2,0.8))
		draw_rect(rec_right,Color(0.2,0.2,0.2,0.8))
		draw_rect(rec_bottom,Color(0.2,0.2,0.2,0.8))
		draw_rect(rec_top,Color(0.2,0.2,0.2,0.8))

func extent2rec():
	rec_left = Rect2(selected_room.global_position - Vector2(selected_extents.x + SIDE_WIDTH, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))
	rec_right = Rect2(selected_room.global_position - Vector2(-selected_extents.x, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))
	
	rec_top = Rect2(selected_room.global_position - Vector2(selected_extents.x, selected_extents.y + VERT_HEIGHT), Vector2(selected_extents.x * 2,VERT_HEIGHT))
	rec_bottom = Rect2(selected_room.global_position - Vector2(selected_extents.x, -selected_extents.y), Vector2(selected_extents.x * 2,VERT_HEIGHT))
