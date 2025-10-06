## MapLayer.gd

class_name MapLayer extends TileMapLayer

@export var tile_size : float = 16
@export var update_bounds : bool = true

func _ready():
	if update_bounds:
		GlobalRegionManager.change_map_bounds(get_map_bounds())
	pass


func get_map_bounds() ->  Array[Vector2]:
	var bounds : Array[Vector2] = []
	bounds.append(
		Vector2( get_used_rect().position * tile_size) + position
	)
	bounds.append(
		Vector2(get_used_rect().end * tile_size) + position
	)
	return bounds
