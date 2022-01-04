# Not to be mistaken with DamageHitbox. This trigger will likely become redundant
extends Trigger

export var damage_amount = 1

func activate():
	#Globals.get_player().state_list[Globals.get_player().current_state].take_damage(1)
	Globals.emit_signal("damage_player", damage_amount)


func on_ready():
	pass
