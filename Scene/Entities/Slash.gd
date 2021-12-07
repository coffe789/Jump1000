extends Sprite
onready var Parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if Parent == Globals.get_player().dash_target_node:
		visible = true
		if Globals.get_player().dash_direction == -1:
			flip_v = true
		else:
			flip_v = false
		if Globals.get_player().facing == 1:
			flip_h = true
		else:
			flip_h = false
	else:
		visible = false
