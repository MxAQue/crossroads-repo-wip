## Plant.gd

class_name Plant extends Node2D

func _ready():
	$HitBox.damaged.connect(take_damage)
	pass

func take_damage(_hurt_box : HurtBox) -> void:
	queue_free()
	pass
