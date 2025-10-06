## quest-advance-trigger.gd
@tool
@icon("res://assets/icons/quest_advance.png")

class_name QuestAdvanceTrigger extends QuestNode

@export_category("Parent Signal Connection")
@export var signal_name : String = ""


## ----------------- FUNCTIONS -------------

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if has_node("Sprite2D"):
		$Sprite2D.queue_free()
	if signal_name != "":
		if get_parent().has_signal(signal_name):
			get_parent().connect( signal_name, advance_quest )


func advance_quest() -> void:
	if linked_quest == null:
		return
	await get_tree().process_frame
	var _title : String = linked_quest.title
	var _step : String = get_step()
	if _step == "N/A":
		_step = ""
	GlobalQuestManager.update_quest(_title, _step, quest_complete)


func _on_pressure_plate_activated() -> void:
	pass # Replace with function body.
