## HurtBox.gd

class_name HurtBox extends Area2D

@export var damage : int = 1
#@export var effect

func _ready():
	area_entered.connect(area_box_entered)
	pass

func area_box_entered (a : Area2D) -> void:
	if a is HitBox:
		a.take_damage(self)
	pass
