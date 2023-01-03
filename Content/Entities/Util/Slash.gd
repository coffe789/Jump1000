extends Sprite
onready var Parent : DashTarget = get_parent()
var is_targeted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("new_dash_target", self, "_on_new_target")

const PLAYER_HEIGHT = 18.0
func set_direction():
	var p = Globals.get_player()
	var relative_pos = p.global_position.y - PLAYER_HEIGHT/2 - global_position.y
	if relative_pos < 0 && p.facing == 1 && not Parent.down_disabled:
		flip_h = true
	elif relative_pos < 0 && p.facing == -1 && not Parent.down_disabled:
		flip_h = false
	elif relative_pos > 0 && p.facing == 1 && not Parent.up_disabled:
		flip_h = false
	elif relative_pos > 0 && p.facing == -1 && not Parent.up_disabled:
		flip_h = true

# When the player chooses a dash target
func _on_new_target(new_target):
	if new_target == get_parent():
		is_targeted = true
		set_direction()
		$AnimationPlayer.play("activate")
		$AnimationPlayer.seek(0)
		$AnimationPlayer.queue("Idle")
	elif is_targeted:
		if $AnimationPlayer.current_animation == "Idle" || "Idle" in $AnimationPlayer.get_queue():
			$AnimationPlayer.play("deactivate")
			$AnimationPlayer.seek(0)
		elif !"deactivate" in $AnimationPlayer.get_queue():
			$AnimationPlayer.queue("deactivate")
		is_targeted = false

func _physics_process(_delta):
	if is_targeted:
		set_direction()
	global_rotation = 0
