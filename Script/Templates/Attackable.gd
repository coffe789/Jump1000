extends Node2D
signal attack_response

#called by the player state
func on_attacked(attack_damage, attack_type):
	pass

func _ready():
	get_node("AttackableArea").connect("area_entered",self, "_on_AttackableArea_area_entered")

#tells the player what it just attacked
func _on_AttackableArea_area_entered(area):
	if area.is_in_group("player_attack"):
		get_tree().call_group("player", "attack_response", 0, self)
