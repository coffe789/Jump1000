tool
extends EditorPlugin

var edi = get_editor_interface()
var selected_room = null

func _ready():   
	set_process_input(true);


func _process(delta): 
	change_selected_room()


func _input(event):
	# Mouse in viewport coordinates
	if Engine.editor_hint:
		if event is InputEventMouseButton && event.button_index == 3 && event.doubleclick && Engine.editor_hint:
			if get_tree().get_nodes_in_group("editor_room").size() != 0:
				for room in get_tree().get_nodes_in_group("editor_room"):
					var is_mouse_in_room = extent2rect(room).has_point(get_tree().get_nodes_in_group("editor_room")[0].get_viewport().get_mouse_position())
					if is_mouse_in_room:
						selected_room = room
						
						var editor_selection = null
						if edi.get_selection().get_selected_nodes().size() > 0:
							editor_selection = edi.get_selection().get_selected_nodes()[0]
						
						select_node(room)
						yield(get_tree(), "idle_frame")
						yield(get_tree(), "idle_frame")
						set_equivalent_child(editor_selection)
		
		if !(event is InputEventMouseMotion) and event.pressed and selected_room:
			if event.as_text() == "Control+T":
				select_node(selected_room.get_node("ResetableNodes/Triggers"))
			if event.as_text() == "Control+R":
				select_node(selected_room.get_node("ResetableNodes/Entities"))
			if event.as_text() == "Alt+1":
				select_node(selected_room.get_node("FGTileMap"))
			if event.as_text() == "Alt+2":
				select_node(selected_room.get_node("BGTileMap"))
			if event.as_text() == "Alt+3":
				select_node(selected_room.get_node("BGDecal"))
			if event.as_text() == "Alt+4":
				select_node(selected_room.get_node("FGDecal"))

func extent2rect(room):
	var extent = room.get_node("CollisionShape2D").shape.extents
	return Rect2(room.global_position-extent,extent*2)

func change_selected_room():
	if Engine.editor_hint && edi.get_selection().get_selected_nodes().size() > 0:
		if edi.get_selection().get_selected_nodes()[0].is_in_group("editor_room"):
			if selected_room != edi.get_selection().get_selected_nodes()[0]:
				selected_room = edi.get_selection().get_selected_nodes()[0]

func select_node(node:Node):
	edi.get_selection().clear()
	edi.get_selection().add_node(node)
	edi.get_selection().emit_signal("selection_changed")

func set_equivalent_child(selected_node):
	if selected_node == null:
		return
	elif selected_node.name == "FGTileMap":
		edi.get_selection().clear()
		edi.get_selection().add_node(selected_room.get_node("FGTileMap"))
	elif selected_node.name == "BGTileMap":
		edi.get_selection().clear()
		edi.get_selection().add_node(selected_room.get_node("BGTileMap"))
	elif selected_node.name == "BGDecal":
		edi.get_selection().clear()
		edi.get_selection().add_node(selected_room.get_node("BGDecal"))
	elif selected_node.name == "FGDecal":
		edi.get_selection().clear()
		edi.get_selection().add_node(selected_room.get_node("FGDecal"))
