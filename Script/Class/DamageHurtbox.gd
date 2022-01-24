extends Area2D
class_name DamageHurtbox
signal damage_received(amount, properties, damage_source)


func _on_DamageHitbox_entered(amount, properties, damage_source):
	# Pass the signal on (to the parent/logic system)
	emit_signal("damage_received", amount, properties, damage_source)
