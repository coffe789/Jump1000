tool
extends Node2D

onready var room = get_parent()
onready var area = room.get_parent()
onready var player_scene = preload("res://Scene/Player/Player.tscn")
var spawn_direction

func _ready():
	if !Engine.editor_hint:
		call_deferred("get_spawn_direction")


func _draw():
	if Engine.editor_hint:
		var editor_rectangle = PoolVector2Array([Vector2(-3.5,-16),Vector2(3.5,-16),Vector2(3.5,0),Vector2(-3.5,0),Vector2(-3.5,-16)])
		draw_polyline(editor_rectangle, Color8(255,0,0))


func get_spawn_direction():
	if abs(room.left_x-position.x) > abs(room.right_x-position.x):
		spawn_direction = -1
	else:
		spawn_direction = 1

func spawn_player():
	Globals.get_player().current_room.exit_room() #we need to exit before killing the player
	var new_player = player_scene.instance()
	new_player.position = global_position
	new_player.collision_mask = Globals.get_player().collision_mask | 16 # enable room boundaries
	new_player.facing = spawn_direction
	area.call_deferred("add_child",new_player)
	
#	Player.position = position
#	Player.state = Player.PS_FALLING
#	Player.facing = spawn_direction
