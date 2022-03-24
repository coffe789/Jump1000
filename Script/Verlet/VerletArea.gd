extends Node2D
onready var PM = preload("res://Scene/Entities/Verlet/PointMass.tscn")
onready var Link = preload("res://Scene/Entities/Verlet/Link.tscn")
onready var Player = get_parent()
onready var CapeL = Player.get_node("Cape/CapeL")
onready var CapeR = Player.get_node("Cape/CapeR")
var PM_list = []
var link_list = [] # Not a linked list lol
onready var spawn_offset = Player.global_position
var PM_spacing_x = 3 # Length of links between nodes
var PM_spacing_y = 6
var grid_size = 3
var accel = Vector2(5,8)

var outline_color = Color(11/255.0,17/255.0,43/255.0)
# Fill colour is set in PM script, couldn't figure out how to do it from here.
var PM_outline = []


func _ready():
	set_as_toplevel(true)
	spawn_PM()
	color_PM()
	init_outline()
	link_PM()
	attach_cape()


func spawn_PM():
	for i in grid_size:
		PM_list.append([])
		for j in grid_size:
			var new_PM = PM.instance()
			new_PM.name = "PointMass" + str(i) + str(j)
			new_PM.global_position = spawn_offset + Vector2(i,0)*PM_spacing_x + Vector2(0,j)*PM_spacing_y
			PM_list[i].append(new_PM)
			add_child(new_PM)
#			if (i==grid_size-1 && j == grid_size):#pull bottom corners apart
#				PM_list[i][j].constant_accel = Vector2(7,0)
#			if (i==0 && j == grid_size-1):
#				PM_list[i][j].constant_accel = Vector2(-7,0)


# Fills the outline array with the outermost nodes (in proper order) (used to draw outline)
func init_outline():
	for i in grid_size:#left
			PM_outline.append(PM_list[0][i])
	for i in grid_size:#bottom
			PM_outline.append(PM_list[i][grid_size-1])
	for i in range(grid_size-1,-1,-1):#right
			PM_outline.append(PM_list[grid_size-1][i])
	for i in range(grid_size-1,-1,-1):#top
			PM_outline.append(PM_list[i][0])


# Fills in middle colour
func color_PM():
	for i in PM_list.size()-1:
		for j in PM_list.size(): #Vertical offset
			PM_list[i][j].drawto.append(PM_list[i+1][j])
	for i in PM_list.size()-1:
		for j in PM_list.size()-1: #Vertical & horizontal offset
			PM_list[i][j].drawto.append(PM_list[i+1][j+1])
	for i in PM_list.size(): #horizontal offset
		for j in PM_list.size()-1:
			PM_list[i][j].drawto.append(PM_list[i][j+1])


func link_PM():
	assert(PM_list.size()>0)
	for i in PM_list.size(): #vertical
		for j in PM_list.size()-1:
			var new_link = Link.instance() 
			new_link.PM_a = PM_list[i][j]
			new_link.is_rigid = true
			new_link.PM_b = PM_list[i][j+1]
			new_link.resting_distance = PM_spacing_y
			link_list.append(new_link)
			#add_child(new_link) #Links must be added to scene to draw their grid
	for i in PM_list.size()-1:
		for j in PM_list.size(): #horizontal
			var new_link = Link.instance()
			new_link.PM_a = PM_list[i][j]
			new_link.PM_b = PM_list[i+1][j]
			new_link.resting_distance = PM_spacing_x
			link_list.append(new_link)
			#add_child(new_link)


func attach_cape():
	var new_link = Link.instance()
	new_link.PM_a = PM_list[0][0]
	new_link.PM_b = CapeL
	new_link.is_PM_a_pin = true
	new_link.resting_distance = 0
	link_list.append(new_link)
	new_link.name = "LeftCapeAttach"
	add_child(new_link)
	
	new_link = Link.instance()
	new_link.PM_a = PM_list[grid_size-1][0]
	new_link.PM_b = CapeR
	new_link.is_PM_b_pin = true
	new_link.resting_distance = 0
	link_list.append(new_link)
	new_link.name = "RightCapeAttach"
	add_child(new_link)


func update_cape(delta):
	#suck_to_mouse(delta)
	for i in link_list.size():
		link_list[i].constrain()
		link_list[i].constrain()
		link_list[i].constrain()
		link_list[i].constrain()
	for i in PM_list.size():
		for j in PM_list.size():
			PM_list[i][j].do_verlet(delta,accel)
	update() # draws outline


func suck_to_mouse(delta):
	var mousepos = get_viewport().get_mouse_position() /4 #4 is the viewport scale
	PM_list[0][0].global_position = PM_list[0][0].global_position.linear_interpolate(mousepos, delta * 40)
	PM_list[grid_size-1][0].global_position = PM_list[0][0].global_position + Vector2((grid_size+1)*PM_spacing_x,0)


func _draw():
	var pva = PoolVector2Array()
	for i in PM_outline.size():
		pva.append(PM_outline[i].get_position()-self.get_position())
	draw_polyline(pva, outline_color,2)
