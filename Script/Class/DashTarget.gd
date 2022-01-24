extends Area2D
class_name DashTarget


func _ready():
	add_to_group("attackable")
	connect("area_entered", self, "_on_DashTarget_area_entered")
	make_dashable()

# Maybe tell parent it's being targeted
func _on_DashTarget_area_entered(_area):
	pass

func make_dashable():
	if is_in_group("undashable"):
		remove_from_group("undashable")
	add_to_group("dashable")
	monitorable = false
	monitorable = true # Ensures the dash area can detect us

func make_undashable():
	remove_from_group("dashable")
	add_to_group("undashable")
	get_tree().call_group("dash_check", "detect_undashable")

func _exit_tree():
	make_undashable() # Makes sure DashCheck nodes remove self from list
