extends StateMachine

var casts

var is_dashing = false
var is_spinning = false
var is_twirling = false # twirl attack
var is_ducking = false
var is_attacking = false
var is_clinging = false

var last_ground_velocity = Vector2(0,0) # Used for platform boost leniency
var last_wall_velocity = Vector2(0,0)

func _ready():
	self.connect("activated",self,"on_activated")
	self.connect("before_updated",self, "on_before_update")
	self.connect("updated",self,"on_update")
	self.connect("changed_state",self, "on_change_state")

func on_activated():
	casts = [target.left_wall_raycast,
	target.right_wall_raycast,
	target.left_wall_raycast2,
	target.right_wall_raycast2,
	target.ledge_cast_lenient,
	target.ledge_cast_top,
	target.ledge_cast_mid,
	target.ledge_cast_bottom,
	target.ledge_cast_height_search]

func on_before_update():
	current_state._check_buffered_inputs()
	current_state.report_collision()
	current_state.set_facing_direction()
	current_state._update_wall_direction()
	current_state.set_player_sprite_direction()
	current_state.set_attack_direction()
	current_state.set_ledge_ray_direction()

func on_update():
	pass
	
	for c in casts:
		c.force_raycast_update()
	

func on_change_state(_old,_new):
	current_state.set_cape_acceleration()
	
	# Note this erases damage properties such as TWIRL
	# Idk if I actually have a use for state_damage_properties
#	target.Attack_Box.damage_properties = current_state.state_damage_properties

#	print(_old.name+"->"+_new.name)

func _on_AttackLengthTimer_timeout():
	is_attacking = false
	target.get_node("CollisionChecks/AttackBox/CollisionShape2D").disabled = true


func _on_TwirlTimer_timeout():
	is_twirling = false


func _on_BoostTimer_timeout():
	last_ground_velocity = Vector2(0,0)
	last_wall_velocity = Vector2(0,0)
