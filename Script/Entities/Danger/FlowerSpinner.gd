extends DamageHitbox
export var frame_count = 5

func _ready():
	damage_properties = [
		Globals.Dmg_properties.FROM_ENVIRONMENT
	]
	
	seed((int(global_position.x) << 10) + int(global_position.y))
	var used_frame = randi()%5
	$FlowerSprite.frame = used_frame
	$OutlineSprite.frame = used_frame
