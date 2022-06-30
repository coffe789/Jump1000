tool
extends Node2D
export var width = 100
export var length_scale = 1.0
export var beam_rotation = 0.0
export var beam_density = 0.8
export var time_scale = 0.333
onready var beam = preload("res://Scene/Entities/Visual/Beam.tscn")

var initial_alpha = modulate.a

func _ready():
	for _i in range(0, int(beam_density * width), 4):
		var new_beam = beam.instance()
		add_child(new_beam)
	for c in get_children():
		c.rotation_degrees = beam_rotation
	animate(0)


func _process(delta):
	if !Engine.editor_hint:
		animate(delta)
	else:
		animate(delta)
		for c in get_children():
			c.rotation_degrees = beam_rotation


var timer = 0
onready var children = get_children()
func animate(delta):
	timer += delta * time_scale
	for i in get_child_count():
		var num = timer * 3 + i * 0.6
		
		var offset = sin(timer + i*10) * 50
		var wideness = sin(num * 0.5 + 1.2) / 2
		var length = get_child_count() + sin(num * 0.25) * 8;
		var a = 0.6 + sin(num + 0.8) * 0.3
		get_children()[i].position.x = offset
		get_children()[i].modulate.a = a * initial_alpha
		get_children()[i].scale = Vector2(wideness * 3, length_scale * length / 20)
