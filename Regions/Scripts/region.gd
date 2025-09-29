## region.gd

class_name Region extends Node2D

@export var music : AudioStream


func _ready() -> void:
	self.y_sort_enabled = true
	GlobalPlayerManager.set_as_parent(self)
	GlobalRegionManager.region_load_started.connect(_free_level)
	GlobalAudioManager.play_music(music)

func _free_level() -> void:
	GlobalPlayerManager.unparent_player(self)
	queue_free()
