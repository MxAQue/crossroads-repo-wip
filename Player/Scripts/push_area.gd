## push_area.gd

extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(b : Node2D) -> void:
	if b is PushableCrate:
		b.push_direction = GlobalPlayerManager.player.direction
		GlobalPlayerManager.player.update_animation("push")

func _on_body_exited(b : Node2D) -> void:
	if b is PushableCrate:
		b.push_direction = Vector2.ZERO
