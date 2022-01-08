extends DamageHitbox
export var frame_count = 6
var Filler = preload("res://Scene/Entities/Danger/Flower/FlowerFiller.tscn")
var is_filled = false

func _ready():
	damage_properties = [
		Globals.Dmg_properties.FROM_ENVIRONMENT
	]
	
	
	seed((int(global_position.x) << 10) + int(global_position.y))
	var used_frame = randi()%frame_count
	$FlowerSprite.frame = used_frame
	$OutlineSprite.frame = used_frame
	
	if Globals.is_resetables_packaged:
		place_all_fillers()


func place_all_fillers():
	is_filled = true
	for flower in get_tree().get_nodes_in_group("flower_spinner"):
		if self.get_instance_id() > flower.get_instance_id() and (flower.position - position).length_squared() < 200:
			spawn_filler((global_position + flower.global_position) / 2 - global_position)


func spawn_filler(pos):
	var new_filler = Filler.instance()
	new_filler.global_position = pos
	new_filler.z_index = z_index - 1
	add_child(new_filler)
