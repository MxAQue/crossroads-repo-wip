## light_flicker.gd

extends PointLight2D

func _ready() -> void:
	flicker()

func flicker() -> void:
	energy = randf() * 0.1 + 0.9
	scale = Vector2(1,1) * energy
	await get_tree().create_timer(0.075).timeout
	flicker()
