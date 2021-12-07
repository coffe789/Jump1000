extends Node2D

onready var room = get_parent()
onready var area = room.get_parent()
onready var Player = get_tree().get_nodes_in_group("player")[0]
onready var player_scene = preload("res://Scene/Player/Player.tscn")
var spawn_direction

func _ready():
	call_deferred("get_spawn_direction")
	yield(get_tree().create_timer(3), "timeout")
	Player.queue_free()
	call_deferred("spawn_player")


func get_spawn_direction():
	if abs(room.left_x-position.x) > abs(room.right_x-position.x):
		spawn_direction = -1
	else:
		spawn_direction = 1

func spawn_player():
	Player.current_room.exit_room()
	var new_player = player_scene.instance()
	new_player.position = global_position
	new_player.collision_mask = Player.collision_mask | 16 # enable room boundaries
	area.add_child(new_player)
	
#	Player.position = position
#	Player.state = Player.PS_FALLING
#	Player.facing = spawn_direction
