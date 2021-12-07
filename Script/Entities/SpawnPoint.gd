extends Node2D

onready var room = get_parent()
onready var area = room.get_parent()
onready var Player = get_tree().get_nodes_in_group("player")[0]
onready var player_scene = preload("res://Scene/Player/Player.tscn")
var spawn_direction

func _ready():
	call_deferred("get_spawn_direction")
#	yield(get_tree().create_timer(3), "timeout")
#	call_deferred("spawn_player")


func get_spawn_direction():
	if abs(room.left_x-position.x) > abs(room.right_x-position.x):
		spawn_direction = -1
	else:
		spawn_direction = 1

func spawn_player():
	var new_player = player_scene.instance()
	new_player.position = position
	area.add_child(new_player)
	
#	Player.position = position
#	Player.state = Player.PS_FALLING
#	Player.facing = spawn_direction
