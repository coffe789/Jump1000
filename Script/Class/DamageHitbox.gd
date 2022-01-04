extends Area2D
class_name DamageHitbox

signal damage_anything(amount, properties, damage_source)

export var damage_amount = 1
var damage_properties = []
var damage_source = self

func _ready():
	connect("area_entered", self, "_on_DamageHitbox_area_entered")
	connect("area_exited", self, "_on_DamageHitbox_area_exited")


func _process(_delta):
	# Signal is received by connected hurtboxes, or if parent wants to know fsr
	emit_signal("damage_anything", damage_amount, damage_properties, damage_source)
#	global_position.x = Globals.get_player().global_position.x


func _on_DamageHitbox_area_entered(area):
	if area is DamageHurtbox:
		connect("damage_anything", area, "_on_DamageHitbox_entered")


func _on_DamageHitbox_area_exited(area):
	if area is DamageHurtbox:
		disconnect("damage_anything", area, "_on_DamageHitbox_area_exited")
