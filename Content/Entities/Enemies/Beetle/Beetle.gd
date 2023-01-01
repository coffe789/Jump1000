extends KinematicBody2D
class_name Beetle
var hp = 4
var velocity = Vector2.ZERO
export var facing = -1

var is_dead := false
var is_flung := false

func _ready():
	$Hurtbox.connect("damage_received", self, "on_hit")
	$WalkDectector.connect("barrier_detected", self, "_on_barrier_detected")
	

	$Hitbox.damage_properties = [
		Globals.Dmg_properties.FROM_ENEMY
	]
	$Hitbox.damage_source = self

	$Hurtbox.hitboxes.append($Hitbox)

	$StateMachine/AnimationPlayer.play("walk")
	$StateMachine.target = self


func _physics_process(delta):
	$StateMachine.update(delta)
	

func on_hit(amount, properties, damage_source):
	if properties.has(Globals.Dmg_properties.FROM_PLAYER) && damage_source != self:
		hp = max(hp - amount, 0)
		if (hp == 0):
			$Hurtbox.do_iframes(false)
			$StateMachine/RootState/Dead.on_hit(amount, properties, damage_source)
			is_dead = true
		else:
			$Hurtbox.do_iframes()
			$StateMachine.current_state.on_hit(amount, properties, damage_source)
		if (hp > 0 and hp <= 2): $Panic.visible = true
		else: $Panic.visible = false

func on_deal_damage(_amount, _properties, _damage_source):
	$FlungTimer.stop()
	is_flung = false

func turn_around(direction):
	$Sprite.scale.x = direction
	$Panic.position.x = -direction * 7
	$Panic.scale.x = direction

func _on_barrier_detected(_type, direction):
	if (!is_dead and is_on_floor()):
		facing = -direction
		turn_around(direction)
