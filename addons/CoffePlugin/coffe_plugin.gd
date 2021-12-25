tool
extends EditorPlugin
signal editor_mouse_click

func _ready():   
	set_process_input(true);


func _process(delta): 
	pass


func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton && event.button_index == 1 && Engine.editor_hint:
		if get_tree().get_nodes_in_group("editor_room").size() != 0:
			print(get_tree().get_nodes_in_group("editor_room")[0].get_viewport().get_mouse_position())
#			get_tree().get_nodes_in_group("edit_assistor")[0].on_mouse_click()
