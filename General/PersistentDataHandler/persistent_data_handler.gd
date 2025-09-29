## persistent_data_handler.gd

class_name PersistentDataHandler extends Node

signal data_loaded
var value : bool = false

func _ready() -> void:
	get_value()

func set_value() -> void:
	GlobalSaveManager.add_persistent_value(_get_name())

func get_value() -> void:
	value = GlobalSaveManager.check_persistent_value(_get_name())
	data_loaded.emit()

func _get_name() -> String:
	# "res//Regions/dungeon_001.tscn/treasurechest/PersistentDataHandler"
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
