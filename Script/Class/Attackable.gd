extends Node2D

func _ready():
	add_to_group("attackable")
	add_user_signal("attack_response",["number"])
