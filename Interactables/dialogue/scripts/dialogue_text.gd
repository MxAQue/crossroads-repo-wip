## dialogue_text.gd
@tool
@icon("res://assets/icons/dialogue/text_bubble.svg")
class_name DialogueText extends DialogueItem

@export_multiline var text : String = "Placeholder text." : set = _set_text
@export var pose : String = "default"
@export var loop_period : float = 2
@export var pose_two: String = ""

## ----------- FUNCTIONS ----------

func _set_editor_display() -> void:
	example_dialogue.set_dialogue_text(self)
	example_dialogue.content.visible_characters = -1

func _set_text(value : String) -> void:
	text = value
	if Engine.is_editor_hint():
		if example_dialogue != null:
			_set_editor_display()
