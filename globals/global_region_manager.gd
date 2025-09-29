# global_region_manager.gd

extends Node

# Signals
signal MapBoundsChanged( bounds : Array[Vector2] )
signal region_load_started
signal region_loaded

# Variables
var current_map_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2


func _ready() -> void:
	await get_tree().process_frame
	region_loaded.emit()

func change_map_bounds(bounds : Array[Vector2]) -> void:
	current_map_bounds = bounds
	MapBoundsChanged.emit(bounds)

func load_new_region(
		region_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out() # Region Transition
	region_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file(region_path)
	
	await SceneTransition.fade_in() # Region Transition
	
	get_tree().paused = false
	
	await get_tree().process_frame
	region_loaded.emit()
