extends KinematicBody2D
var hp = 4
var velocity = Vector2.ZERO
const GRAVITY = 9.8
const WALK_SPEED = 50
export var facing = -1

var is_dead := false


func _ready():
	$Hurtbox.connect("damage_received", self, "on_hit")
	$WalkDectector.connect("barrier_detected", self, "_on_barrier_detected")

func _physics_process(_delta):
	if (!is_dead):
		velocity.x = WALK_SPEED * facing
	else:
		if (is_on_floor()): velocity.x *= 0.8	

	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 100) # Cap fall speed

	velocity = move_and_slide(velocity, Vector2.UP)
	

func on_hit(amount, properties, damage_source):
	if properties.has(Globals.Dmg_properties.FROM_PLAYER):
		print(amount)
		hp = max(hp - amount, 0)
		$Hurtbox.do_iframes()
		if (hp == 0): is_dead = true
	
	if (is_dead):
		if (properties.has(Globals.Dmg_properties.PLAYER_THRUST) 
				or properties.has(Globals.Dmg_properties.DASH_ATTACK_UP)
				or properties.has(Globals.Dmg_properties.DASH_ATTACK_DOWN)):
			var xdir = damage_source.facing
			velocity = Vector2(xdir * 100, -100)
			
	
func _on_barrier_detected(_type, direction):
	if (!is_dead and is_on_floor()):
		facing = -direction	
