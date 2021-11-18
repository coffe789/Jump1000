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
	DASH_BONK,
	NO_RESPONSE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func is_same_sign(num1,num2):
	if num1 == 0 || num2 == 0:
		return true
	if num1 > 0 && num2 > 0:
		return true
	if num1 < 0 && num2 < 0:
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
