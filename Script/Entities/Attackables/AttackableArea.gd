extends Area2D
signal been_attacked #let parent know it was attacked

func _ready():
	get_parent().connect("been_attacked", self, "on_attacked")



func _on_AttackableArea_body_shape_entered(body_id, body, body_shape, local_shape):
	pass # Replace with function body.
