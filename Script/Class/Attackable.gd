extends Node2D
class_name Attackable
onready var Attackable_Area = get_node("AttackableArea") #All attackables must have an area called this

signal attack_response
var last_seen_attack_id = -1
var Player

#called by the player state
func on_attacked(attack_damage, attack_type):
	pass

func _ready():
	self.add_to_group("attackable")
	Player = get_tree().get_nodes_in_group("player")[0]
	Attackable_Area.connect("area_entered", self, "_on_AttackableArea_area_entered")

# Tell the player what it just attacked
func _on_AttackableArea_area_entered(area):
	if area.is_in_group("player_attack") && Player.current_attack_id != last_seen_attack_id:
		last_seen_attack_id = Player.current_attack_id
		get_tree().call_group("player", "attack_response", Globals.NORMAL_STAGGER, self)

func make_dashable():
	self.remove_from_group("undashable")
	self.add_to_group("dashable")
	Attackable_Area.monitorable = false
	Attackable_Area.monitorable = true # Ensures the dash area can detect us

func make_undashable():
	self.remove_from_group("dashable")
	self.add_to_group("undashable")
	get_tree().call_in_group("dash_area", "detect_undashable")
