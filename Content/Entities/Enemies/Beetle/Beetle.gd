extends KinematicBody2D
var hp = 4
var velocity = Vector2.ZERO
export var facing = -1

var is_dead := false


func _ready():
	$Hurtbox.connect("damage_received", self, "on_hit")
	$WalkDectector.connect("barrier_detected", self, "_on_barrier_detected")
	
	$StateMachine/AnimationPlayer.play("walk")

	$Hitbox.damage_properties = [
		Globals.Dmg_properties.FROM_ENEMY
	]
	$StateMachine.target = self


func _physics_process(delta):
	$StateMachine.update(delta)
	

func on_hit(amount, properties, damage_source):
	if properties.has(Globals.Dmg_properties.FROM_PLAYER):
		hp = max(hp - amount, 0)
		$Hurtbox.do_iframes()
		if (hp == 0):
			$StateMachine/RootState/Dead.on_hit(amount, properties, damage_source)
			is_dead = true
		else:
			$StateMachine.current_state.on_hit(amount, properties, damage_source)


func _on_barrier_detected(_type, direction):
	if (!is_dead and is_on_floor()):
		facing = -direction
		$Sprite.scale.x = sign(direction)
