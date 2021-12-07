extends Node2D
onready var room = get_parent()
onready var area = room.get_parent()

func _ready():
	pass
	#self.set_owner(get_tree().get_edited_scene_root())

func create_scene():
	var packed_scene = PackedScene.new()
	for child in get_all_descendants(self,[]):
		child.owner = self
	packed_scene.pack(self)
	ResourceSaver.save(
		"res://Scene/CodeGenerated/ResetableNodes/"
		+ area.name
		+ room.name
		+ ".tscn",
		packed_scene)
	return packed_scene

func get_all_descendants(node, array):
	if node.get_child_count() > 0:
		for child in node.get_children():
			array.append(child)
			array.append_array(get_all_descendants(child, array))
	return array
