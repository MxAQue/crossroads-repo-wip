## CharacterCreator.gd
extends Node2D

# Node ref
@onready var name_box = $CreatorScreen/CreatorPanel/LeftBottom/Name/EditName
var player_name = ""

# Player name
func _on_edit_name_text_changed() -> void:
	player_name = name_box.text

# Change scene
func _on_confirm_button_pressed() -> void:
	Global.player_name = player_name
	get_tree().change_scene_to_file("res://Regions/main.tscn")


func _on_collection_back_button_pressed() -> void:
	pass # Replace with function body.
