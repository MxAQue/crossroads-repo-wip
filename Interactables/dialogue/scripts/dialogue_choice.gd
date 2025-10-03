## dialogue_choice.gd
@tool
@icon("res://assets/icons/dialogue/question_bubble.svg")
class_name DialogueChoice extends DialogueItem

var dialogue_branches : Array[DialogueBranch]


## ----------- FUNCTIONS -----------

func _ready() -> void:
	super()
	for c in get_children():
		if c is DialogueBranch:
			dialogue_branches.append(c)

func _set_editor_display() -> void:
	#set the text based on related dialogue text node
	set_related_text()
	#set dialogue choice buttons
	if dialogue_branches.size() <2:
		return
	example_dialogue.set_dialogue_choice(self)
	pass


func set_related_text() -> void:
	#find the sibling
	var _p = get_parent()
	var _t = _p.get_child(self.get_index() -1)
	#set text based on sibling
	if _t is DialogueText:
		example_dialogue.set_dialogue_text(_t)
		example_dialogue.content.visible_characters = -1

# Warning Configuration
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialogue_branches() == false:
		return["Requires at least 2 DialogueBranch nodes"]
	else:
		return[]

func _check_for_dialogue_branches() -> bool:
	var _count : int = 0
	for c in get_children():
		_count+= 1
		if _count > 1:
			return true
	return false
