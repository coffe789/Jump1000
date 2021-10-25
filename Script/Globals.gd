extends Node

# Types of attacks the player can do
enum \
{
	NORMAL_ATTACK,
	DASH_ATTACK_UP,
	DASH_ATTACK_DOWN
}

# Ways player can react after attacking an object
enum \
{
	NORMAL_STAGGER,
	DASH_DOWN_STAGGER,
	DASH_UP_STAGGER,
	CONTINUE_DASH
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
