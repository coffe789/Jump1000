extends Area2D
var areas_inside_count = 0
var area_list = []
onready var Player = get_parent().get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# If a detected area becomes undashable while inside this messes up the count
# So when an area loses its dashability it tells this node to check if it should reduce its count
func detect_undashable():
	for i in range(area_list.size()-1,-1,-1):
		if area_list[i].is_in_group("undashable"):
			area_list[i].remove()
			areas_inside_count -= 1


func _on_DashCheckUp_area_entered(area):
	if area.is_in_group("dashable"):
		areas_inside_count += 1
		#Player.can_dash_up = true
		area_list.append(area)


func _on_DashCheckUp_area_exited(area):
	if area.is_in_group("dashable"):
		areas_inside_count -= 1
		area_list.erase(area)
		assert(areas_inside_count>=0)
#		if (areas_inside_count == 0):
#			Player.can_dash_up = false
