extends Node2D
signal attack_response

func on_attacked():
	get_tree().call_group("player", "attack_response", 0)
