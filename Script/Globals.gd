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

# Ledge grab behaviours
enum \
{
	LEDGE_REST,
	LEDGE_NO_ACTION,
	LEDGE_EXIT,
	LEDGE_LENIENCY_RISE
}

func is_same_sign(num1,num2):
	if num1 == 0 || num2 == 0:
		return true
	if num1 > 0 && num2 > 0:
		return true
	if num1 < 0 && num2 < 0:
		return true
	return false


# For debug
func clear_console():
	for i in 20:
		print("\n")

func get_player():
	return get_tree().get_nodes_in_group("player")[0]

func get_all_descendants(node, array):
	if node.get_child_count() > 0:
		for child in node.get_children():
			array.append(child)
			array.append_array(get_all_descendants(child, array))
	return array
