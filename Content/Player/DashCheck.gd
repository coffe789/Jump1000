extends Area2D
var areas_inside_count = 0
var area_list = []
onready var Player = get_parent().get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("room_transitioned",self, "detect_undashable")

func _on_DashCheck_area_entered(area):
	if area.is_in_group("dashable"):
		areas_inside_count += 1
#		Player.can_dash_down = true
		area_list.append(area)
	
func _on_DashCheck_area_exited(area):
	if area.is_in_group("dashable") and area_list.has(area):
		areas_inside_count -= 1
		area_list.erase(area)
		assert(areas_inside_count>=0)
#		if (areas_inside_count == 0):
#			Player.can_dash_down = false


# Remove nodes that have been deleted or became undashable
func detect_undashable(_from_room, _to_room):
	for i in range(area_list.size()-1,1,-1):
		if !is_instance_valid(area_list[i]) || !area_list[i].is_in_group("dashable"):
			area_list.remove(i)
			areas_inside_count -= 1


