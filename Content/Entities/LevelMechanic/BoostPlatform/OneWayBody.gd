extends TileProxy

func collide_with(_normal, collider):
	get_parent().collide_with(_normal, collider)
