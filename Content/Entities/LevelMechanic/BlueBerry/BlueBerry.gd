extends Sprite
var speed = 0.0
var accel = 0.0

func _ready():
	$DashTarget.connect("dash_used", self, "_on_dash_used")
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(randf() * 10)

func _on_dash_used():
	speed += 1.5 * Globals.get_player().facing

var prev_degrees = 0
func _physics_process(_delta):
	accel = -sin(rotation)
	rotation_degrees += speed
	speed = (rotation_degrees-prev_degrees)*0.96
	prev_degrees = rotation_degrees
	rotation_degrees += accel / 2
