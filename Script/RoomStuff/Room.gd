extends Area2D

func _ready():
	add_to_group("room")

func enter_room():
	print("enter room",self.name)

func exit_room():
	print("exit room",self.name)
