extends Node2D
signal attack_response
var last_seen_attack_id = -1
var Player

var health = 5

#called by the player state
func on_attacked(attack_damage, attack_type):
	health -= attack_damage
	if health <= 0:
		queue_free()

func _ready():
	Player = get_tree().get_nodes_in_group("player")[0]
	get_node("AttackableArea").connect("area_entered",self, "_on_AttackableArea_area_entered")

# Tell the player what it just attacked
func _on_AttackableArea_area_entered(area):
	if area.is_in_group("player_attack") && Player.current_attack_id != last_seen_attack_id:
		last_seen_attack_id = Player.current_attack_id
		get_tree().call_group("player", "attack_response", Globals.NORMAL_STAGGER, self)
