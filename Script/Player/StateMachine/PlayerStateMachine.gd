extends StateMachine

var is_dashing = false
var is_spinning = false
var is_twirling = false # twirl attack
var is_ducking = false
var is_attacking = false

func _ready():
	self.connect("before_updated",self, "on_before_update")
	self.connect("updated",self,"on_update")
	self.connect("changed_state",self, "on_change_state")

func on_before_update():
	current_state._check_buffered_inputs()

func on_update():
	current_state._update_wall_direction()
	current_state.set_facing_direction()
	current_state.set_player_sprite_direction()
	current_state.set_attack_direction()
	current_state.set_ledge_ray_direction()

func on_change_state(_old,_new):
	current_state.set_cape_acceleration()
	print(_old.name+"->"+_new.name)


func _on_AttackLengthTimer_timeout():
	is_attacking = false
	target.get_node("CollisionChecks/AttackBox/CollisionShape2D").disabled = true


func _on_TwirlTimer_timeout():
	is_twirling = false
