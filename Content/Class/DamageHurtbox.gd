extends Area2D
class_name DamageHurtbox
signal damage_received(amount, properties, damage_source)

export var i_seconds = 0.2
var i_timer = Timer.new()

var hitboxes = [] # An array of hitboxes to be disabled after being hit
export var hit_disable_time = 0.25 # How long to disable the hitboxes for

func _ready():
	i_timer.one_shot = true
	add_child(i_timer)

func do_iframes(disable_hitboxes : bool = true):
	if disable_hitboxes:
		disable_hitboxes()
	i_timer.start(i_seconds)

func disable_hitboxes():
	for hitbox in hitboxes:
		hitbox.temp_disable(hit_disable_time)

func _on_DamageHitbox_entered(amount, properties, damage_source):
	if i_timer.time_left == 0 and i_timer.is_stopped():
		# Pass the signal on (to the parent/logic system)
		emit_signal("damage_received", amount, properties, damage_source)
