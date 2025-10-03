## dialogue_item.gd
@tool
@icon("res://assets/icons/dialogue/chat_bubble.svg")
class_name DialogueItem extends Node

@export var npc_info : NPCResource

var editor_selection #: EditorSelection - removed to avoid runtime bug
var example_dialogue : DialogueSystemNode

## -------------- FUNCTION -------------

func _ready() -> void:
	if Engine.is_editor_hint():
		#editor_selection = EditorInterface.get_selection()
		editor_selection = Engine.get_singleton("EditorInterface").get_selection()
		editor_selection.selection_changed.connect(_on_selection_change)
		return
	check_npc_data()


func check_npc_data() -> void:
	if npc_info == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.npc_resource:
					npc_info = p.npc_resource
					_checking = false
			else:
				_checking = false

func _on_selection_change() -> void:
	if editor_selection == null:
		return
	var sel = editor_selection.get_selected_nodes()
	
	if example_dialogue != null:
		example_dialogue.queue_free()
	
	if not sel.is_empty():
		if self == sel[0]:
			example_dialogue = load("res://gui/dialogue_system/dialogue_system.tscn").instantiate() as DialogueSystemNode
			if example_dialogue == null:
				return
			self.add_child(example_dialogue)
			example_dialogue.offset = get_parent_global_position() + Vector2( 32, -200 )
			check_npc_data()
			_set_editor_display()

func get_parent_global_position() -> Vector2:
	var p = self
	var _checking : bool = true
	while _checking == true:
		p = p.get_parent()
		if p:
			if p is Node2D:
				return p.global_position
		else:
			_checking = false
	return Vector2.ZERO

func _set_editor_display() -> void:
	pass
