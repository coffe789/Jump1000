# This script is to be used as a template by anything the player can attack
extends Attackable

func _ready():
	self.add_to_group("attackable")
	make_dashable()
	Attackable_Area.connect("area_entered", self, "_on_AttackableArea_area_entered")
