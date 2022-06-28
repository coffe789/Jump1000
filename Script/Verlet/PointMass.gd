extends Node2D
onready var area = get_node("Area2D")
var velocity = Vector2(0,0)
var entered_body = false;
var is_pin = false
var collision_factor = 0.5 #Read docs for what this does
var dampen_factor = 0.9
var fill_color = PoolColorArray([Color(211/255.0,158/255.0,19/255.0)])
var constant_accel = Vector2() #Constantly applied on top of regular acceleration

var drawto = [self]
var drawto_size

func _ready():
	if !is_pin:
		add_to_group("cape_point")
	set_as_toplevel(true)

func _draw():
	if drawto.size() == 4:
		var pva = PoolVector2Array()
		for i in drawto.size():
			pva.append(drawto[i].get_position()-self.get_position())
		draw_primitive(pva, fill_color,PoolVector2Array())

func _physics_process(_delta):
	update()

onready var last_position = position
var next_position

func do_verlet(delta,accel):
	var mult = 1
	velocity = position - last_position
	last_position = position
	if (entered_body): #collision
		mult = 0
		position = last_position
		velocity *= -collision_factor
	velocity *= dampen_factor # damping
	position = position + (velocity*delta*60) + (accel + constant_accel) * delta * mult

func _on_Area2D_body_entered(body):
	if (body is CollisionObject2D || body is TileMap):
		entered_body=true;

func _on_Area2D_body_exited(body):
	if (body is CollisionObject2D || body is TileMap):
		entered_body = false
