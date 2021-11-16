extends Node2D
class_name Attackable
onready var Attackable_Area = get_node("AttackableArea") #All attackables must have an area called this

var last_seen_attack_id = -1
var Player

#called by the player state
func on_attacked(_attack_damage, _attack_type):
	pass

func _ready():
	Attackable_Area.add_to_group("attackable")
	Player = get_tree().get_nodes_in_group("player")[0]
	Attackable_Area.connect("area_entered", self, "_on_AttackableArea_area_entered")

# TODO: This needs to get the attack type before choosing the response
# Tell the player what it just attacked
func _on_AttackableArea_area_entered(area):
	if area.is_in_group("player_attack") && Player.current_attack_id != last_seen_attack_id:
		last_seen_attack_id = Player.current_attack_id
		if Player.last_attack_type == Globals.NORMAL_ATTACK:
			get_tree().call_group("player", "attack_response", Globals.NO_RESPONSE, self)
		else:
			get_tree().call_group("player", "attack_response", Globals.NO_RESPONSE, self)

func make_dashable():
	if Attackable_Area.is_in_group("undashable"):
		Attackable_Area.remove_from_group("undashable")
	Attackable_Area.add_to_group("dashable")
	Attackable_Area.monitorable = false
	Attackable_Area.monitorable = true # Ensures the dash area can detect us

func make_undashable():
	Attackable_Area.remove_from_group("dashable")
	Attackable_Area.add_to_group("undashable")
	get_tree().call_in_group("dash_area", "detect_undashable")
