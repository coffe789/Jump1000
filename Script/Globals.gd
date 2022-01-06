extends Node

signal player_connect_cam(player)
signal set_cam_limit(which_limit, limit_pos)
signal player_freed
signal room_transitioned

signal set_camera_offset(offset, ignore_X_or_Y) # Second parameter is a Vector2 with 1/0 masks

# Types of damage properties
enum Dmg_properties {
	FROM_PLAYER,
	FROM_ENEMY,
	FROM_ENVIRONMENT,
	
	PLAYER_ATTACK,
	DASH_ATTACK_UP,
	DASH_ATTACK_DOWN,
}

# Ways player can react after attacking an object
enum {
	NORMAL_STAGGER,
	DASH_BONK,
	NO_RESPONSE,
}

# Ledge grab behaviours
enum {
	LEDGE_REST,
	LEDGE_NO_ACTION,
	LEDGE_EXIT,
	LEDGE_LENIENCY_RISE,
}


# Util
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
