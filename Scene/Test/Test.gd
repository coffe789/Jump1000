extends Node2D
onready var node_one = get_node("Position2D")
onready var node_two = get_node("Position2D2")
var mouse_in = false;

func approach(to_change, maximum, change_by):
	assert(change_by>=0)
	var approach_direction = 0;
	if (maximum > to_change):
		approach_direction = 1
	elif (maximum < to_change):
		approach_direction = -1
	to_change += change_by * approach_direction;
	if (approach_direction == -1 && to_change < maximum):
		to_change = maximum
	elif (approach_direction == 1 && to_change > maximum):
		to_change = maximum
	return to_change

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var v1 =0.0
var v2 =0.0
var t= 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	t += delta
	var distance = trig_distance($Position2D.position,$Position2D2.position)
	$Position2D2.position = $Position2D2.position.linear_interpolate($Position2D.position, delta * 20)
	var mousepos = get_viewport().get_mouse_position()
	if (mouse_in && Input.is_action_pressed("mouse_click")):
		node_one.global_position.x = approach(node_one.global_position.x,mousepos.x,delta*10000)
		node_one.global_position.y = approach(node_one.global_position.y,mousepos.y,delta*10000)
	v2 = approach(v2,40,delta*60)
	$Position2D2.position.y += v2
#	if (distance > 20):
#		node_two.global_position.x = approach(node_two.global_position.x,node_one.global_position.x,delta*distance_factor)
#		node_two.global_position.y = approach(node_two.global_position.y,node_one.global_position.y,delta*distance_factor)

func trig_distance(a,b):
	var c = sqrt(pow((a.x -b.x),2) + pow((a.y - b.y),2))
	return c

func _on_Area2D_mouse_entered():
	mouse_in = true


func _on_Area2D_mouse_exited():
	if !Input.is_action_pressed("mouse_click"):
		mouse_in = false
