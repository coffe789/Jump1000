extends Area2D
class_name DashTarget
signal dash_used


func _ready():
	make_dashable()

# When the player uses the area to dash
func on_used():
	emit_signal("dash_used")

func make_dashable():
	add_to_group("dashable")
	monitorable = false
	monitorable = true # Ensures the dash area can detect us

func make_undashable():
	remove_from_group("dashable")
	get_tree().call_group("dash_check", "detect_undashable")

func _exit_tree():
	make_undashable() # Makes sure DashCheck nodes remove self from list
