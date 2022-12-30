extends KinematicBody2D
var hp = 1

func _ready():
	$HurtBox.connect("damage_received", self, "on_hit")

func on_hit(damage_amount, properties, _damage_source):
	if (properties.has(Globals.Dmg_properties.FROM_PLAYER) && damage_amount > 0):
		hp = max(hp - 1, 0) # damage_amount does not matter	
		if (hp == 0): queue_free()

