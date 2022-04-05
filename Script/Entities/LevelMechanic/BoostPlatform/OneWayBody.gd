extends KinematicBody2D

func collide_with(_normal, collider):
	get_parent().collide_with(_normal, collider)
