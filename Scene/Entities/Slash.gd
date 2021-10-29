extends Sprite
onready var Parent = get_parent()
onready var Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_nodes_in_group("player").size()>0:
		Player = get_tree().get_nodes_in_group("player")[0]
	else:
		print("Player not found from slash node: ", self)

func _process(_delta):
	if Parent == Player.dash_target_node:
		visible = true
		if Player.dash_direction == -1:
			flip_v = true
		else:
			flip_v = false
		if Player.facing == 1:
			flip_h = true
		else:
			flip_h = false
	else:
		visible = false
