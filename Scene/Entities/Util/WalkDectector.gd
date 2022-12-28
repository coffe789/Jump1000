extends Node2D
class_name walk_detector

signal barrier_detected(type, direction)

enum {WALL_BARRIER, GAP_BARRIER}

func _physics_process(_delta):
	if ($HLeft.get_collider() && $HLeft.get_collision_normal() == Vector2.RIGHT):
		emit_signal("barrier_detected", WALL_BARRIER, -1)
	if ($HRight.get_collider() && $HRight.get_collision_normal() == Vector2.LEFT):
		emit_signal("barrier_detected", WALL_BARRIER, +1)

	if ($VLeft.get_collider() == null):
		emit_signal("barrier_detected", GAP_BARRIER, -1)
	if ($VRight.get_collider() == null):
		emit_signal("barrier_detected", GAP_BARRIER, +1)



func disable():
	$HLeft.enabled = false
	$HRight.enabled = false
	$VLeft.enabled = false
	$VRight.enabled = false

func enable():
	$HLeft.enabled = true
	$HRight.enabled = true
	$VLeft.enabled = true
	$VRight.enabled = true
