extends Node

signal damage_player(damage)
signal enter_room_killbox
signal player_connect_cam(player)
signal set_cam_limit(which_limit, limit_pos)
signal player_freed
signal room_transitioned

signal set_camera_offset(offset, ignore_X_or_Y) # Second parameter is a Vector2 with 1/0 masks

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
	if get_tree().get_nodes_in_group("player") != []:
		return get_tree().get_nodes_in_group("player")[0]
	return null

func get_cam():
	if get_tree().get_nodes_in_group("player_camera") != []:
		return get_tree().get_nodes_in_group("player_camera")[0]
	return null

func get_all_descendants(node, array):
	#These lines turn all scenes into local branches to prevent a duplication bug
	node.set_filename("") 
	node.owner=get_tree().get_edited_scene_root()
	
	if node.get_child_count() > 0:
		for child in node.get_children():
			array.append(child)
			array.append_array(get_all_descendants(child, array))
	return array
