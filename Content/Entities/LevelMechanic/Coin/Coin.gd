extends Node2D

func _ready():
	$Sprite/AnimationPlayer.play("spin")

func _on_Area2D_body_entered(body):
	if body is Player:
		queue_free()


func _on_DamageHurtbox_damage_received(amount, properties, damage_source):
	if properties.has(Globals.Dmg_properties.FROM_PLAYER):
		queue_free()
