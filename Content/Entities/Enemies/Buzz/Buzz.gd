extends KinematicBody2D
enum FlightDirection {LEFT, UP, RIGHT, DOWN}
export(FlightDirection) var init_direction = FlightDirection.LEFT

var direction : Vector2
var velocity : Vector2
var hp = 4
var is_boinked := false

func set_init_direction():
	match init_direction:
		FlightDirection.LEFT:
			direction = Vector2.LEFT
		FlightDirection.UP:
			direction = Vector2.UP
		FlightDirection.RIGHT:
			direction = Vector2.RIGHT
		FlightDirection.DOWN:
			direction = Vector2.DOWN

func on_hit(amount, properties, damage_source):
	if properties.has(Globals.Dmg_properties.FROM_PLAYER) && damage_source != self:
		hp = max(hp - amount, 0)
		$HurtBox.do_iframes()
		$StateMachine.current_state.on_hit(amount, properties, damage_source)

func _ready():
	set_init_direction()
	velocity = direction * $StateMachine/RootState.MAX_SPEED

	$HurtBox.connect("damage_received", self, "on_hit")
	$HurtBox.hit_disable_time = 0.4
	$HurtBox.hitboxes.append($DamageHitbox)

	$StateMachine.target = self

func _physics_process(delta):
	$StateMachine.update(delta)
