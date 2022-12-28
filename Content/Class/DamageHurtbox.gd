extends Area2D
class_name DamageHurtbox
signal damage_received(amount, properties, damage_source)

export var i_seconds = 0
var i_timer = Timer.new()

func _ready():
	i_timer.one_shot = true
	add_child(i_timer)

func do_iframes():
	i_timer.start(i_seconds)

func _on_DamageHitbox_entered(amount, properties, damage_source):
	if i_timer.time_left == 0 and i_timer.is_stopped():
		# Pass the signal on (to the parent/logic system)
		emit_signal("damage_received", amount, properties, damage_source)
