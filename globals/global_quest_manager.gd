## global_quest_manager.gd

extends Node

const QUEST_DATA_LOCATION : String = "res://quests/"

signal quest_updated(q)

var quests : Array[Quest]
var current_quests : Array = []

## --------------------- FUNCTIONS ---------------

func _ready() -> void:
	gather_quest_data()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_test"):
		#print( find_quest_index_by_title("Recover Oren's Lost Flute"))
		#print( find_quest_index_by_title("short quest"))
		#print( find_quest_by_title("Shortp quest"))
		#print( find_quest( load("res://quests/000_recover_lost_flute.tres") as Quest ) )
		#print ("before:"p, current_quests)
		#update_quest("Recover Oren's Lost Flute")
		#update_quest("Recover Oren's Lost Flute", "", true)
		#update_quest("short quest", "", true)
		#update_quest("Long Quest","step 1")
		#update_quest("Long Quest","step 2")
		print ("quests", current_quests)
		#print ("======================")
		pass
		

func gather_quest_data() -> void:
	var quest_files : PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	for q in quest_files:
		quests.append( load(QUEST_DATA_LOCATION + "/" + q) as Quest )


func update_quest(_title : String, _completed_step : String = "", _is_complete : bool = false) -> void:
	var quest_index : int = find_quest_index_by_title(_title)
	if quest_index == -1:
		var new_quest : Dictionary = {
				title = _title,
				is_complete = _is_complete,
				completed_steps = []
			}
		if _completed_step != "":
			new_quest.completed_steps.append( _completed_step.to_lower() )
		current_quests.append(new_quest)
		quest_updated.emit(new_quest)
		PlayerHUD.queue_notification("Quest Started", _title)
	else:
		var q = current_quests[quest_index]
		if _completed_step != "" and q.completed_steps.has(_completed_step) == false:
			q.completed_steps.append( _completed_step.to_lower() )
		q.is_complete = _is_complete
		quest_updated.emit(q)
		if q.is_complete == true:
			PlayerHUD.queue_notification("Quest Complete!", _title)
			disperse_quest_rewards( find_quest_by_title(_title) )
		else:
			PlayerHUD.queue_notification("Quest Updated", _title + ": " + _completed_step)


func disperse_quest_rewards(_q : Quest) -> void:
	var _message : String = str(_q.reward_xp) + " XP"
	GlobalPlayerManager.reward_xp(_q.reward_xp)
	for i in _q.reward_items:
		GlobalPlayerManager.INVENTORY_DATA.add_item(i.item, i.quantity)
		_message += ", " + i.item.name + " (" + str(i.quantity) + ")"
	PlayerHUD.queue_notification("Quest Rewards Received!", _message)

func find_quest(_quest : Quest) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() == _quest.title.to_lower():
			return q
	return {title = "not found", is_complete = false, completed_steps = [''] }

func find_quest_by_title(_title : String) -> Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower():
			return q
	return null

func find_quest_index_by_title(_title : String) -> int:
	for i in current_quests.size():
		if current_quests[i].title.to_lower() == _title.to_lower():
			return i
	return -1

func sort_quests() -> void:
	var active_quests : Array = []
	var completed_quests : Array = []
	for q in current_quests:
		if q.is_complete:
			completed_quests.append(q)
		else:
			active_quests.append(q)
	active_quests.sort_custom(sort_quests_ascending)
	completed_quests.sort_custom(sort_quests_ascending)
	
	current_quests = active_quests
	current_quests.append_array(completed_quests)

func sort_quests_ascending(a,b):
	if a.title < b.title:
		return true
	return false
