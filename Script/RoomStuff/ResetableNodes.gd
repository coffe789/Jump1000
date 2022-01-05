extends Node2D
onready var room = get_parent()
onready var area = room.get_parent()

func _ready():
	pass
	#self.set_owner(get_tree().get_edited_scene_root())

func create_scene():
	var packed_scene = PackedScene.new()
	recursive_set_owner(self)
	packed_scene.pack(self)
#	ResourceSaver.save(
#		"user://" # Can't write to res:// during runtime
#		+ area.name
#		+ room.name
#		+ ".tscn",
#		packed_scene)
	return packed_scene

func recursive_set_owner(node):
	#This line turns all scenes into local branches to prevent a duplication bug
	node.set_filename("")
	
	if node != self:
		node.set_owner(self)
	for child in node.get_children():
		recursive_set_owner(child)
	return
