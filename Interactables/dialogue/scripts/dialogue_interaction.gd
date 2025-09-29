## dialogue_interaction.gd
@tool
@icon("res://assets/icons/dialogue/chat_bubbles.svg")
class_name DialogueInteraction extends Area2D

signal player_interacted
signal finished

@export var enabled : bool = true

var dialogue_items : Array[DialogueItem]
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## ------------- FUNCTIONS

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	
	for c in get_children():
		if c is DialogueItem:
			dialogue_items.append(c)

func player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogueSystem.finished.connect(_on_dialogue_finished)
	DialogueSystem.show_dialogue(dialogue_items)


func _on_area_enter(_a : Area2D) -> void:
	if enabled == false || dialogue_items.size() == 0:
		return
	animation_player.play("show")
	GlobalPlayerManager.interact_pressed.connect(player_interact)

func _on_area_exit(_a : Area2D) -> void:
	animation_player.play("hide")
	GlobalPlayerManager.interact_pressed.disconnect(player_interact)

func _on_dialogue_finished() -> void:
	DialogueSystem.finished.disconnect(_on_dialogue_finished)
	finished.emit()

func _get_configuration_warnings() -> PackedStringArray:
	# check for dialogue items
	if _check_for_dialogue_items() == false:
		return["Requires at least one DialogueItem node"]
	else:
		return[]

func _check_for_dialogue_items() -> bool:
	for c in get_children():
		if c is DialogueItem:
			return true
	return false
