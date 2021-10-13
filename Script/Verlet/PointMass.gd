extends Node2D
onready var area = get_node("Area2D")
var velocity = Vector2(0,0)
var acceleration = Vector2(5,8) #gravity or other external forces
var entered_body = false;
var is_pin = false
var collision_factor = 0.3 #Read docs for what this does
var dampen_factor = 0.96
var fill_color = PoolColorArray()

var drawto = [self]
var drawto_size

func _ready():
	fill_color.append(Color(213/255.0,39/255.0,64/255.0))

func _draw():
	if drawto.size() == 4:
		var pva = PoolVector2Array()
		for i in drawto.size():
			pva.append(drawto[i].get_position()-self.get_position())
		draw_primitive(pva, fill_color,PoolVector2Array())

func _physics_process(delta):
	update()

onready var last_position = position
var next_position

func do_verlet(delta):
	var mult = 1
	velocity = position - last_position
	last_position = position
	if (entered_body): #collision
		mult = 0
		position = last_position
		velocity *= -collision_factor
	velocity *= dampen_factor # damping
	position = position + (velocity*delta*60) + (acceleration*delta * mult)

func _on_Area2D_body_entered(_body):
	entered_body=true;

func _on_Area2D_body_exited(_body):
	entered_body = false
