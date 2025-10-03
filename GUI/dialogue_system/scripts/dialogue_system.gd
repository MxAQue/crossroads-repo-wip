## dialogue_system.gd
@tool
@icon("res://assets/icons/dialogue/star_bubble.svg")

class_name DialogueSystemNode extends CanvasLayer

var shader = preload("res://globals/shaders/palette_swaps.gdshader")

signal finished
signal letter_added(letter : String)

# Variables
var is_active : bool = false
var text_in_progress : bool = false
var waiting_for_choice : bool = false


var text_speed : float = 0.02
var text_length : int = 0
var plain_text : String

var dialogue_items : Array[DialogueItem]
var dialogue_item_index : int = 0

# References
@onready var dialogue_ui: Control = $DialogueUI
@onready var content: RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogueUI/NameLabel
@onready var pronouns_label: Label = $DialogueUI/PronounsLabel
@onready var dialogue_progress_indicator: PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label: Label = $DialogueUI/DialogueProgressIndicator/Label
@onready var dialogue_animation: AnimationPlayer = $DialogueUI/PortraitArea/Skeleton/DialogueAnimation
@onready var timer: Timer = $DialogueUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogueUI/AudioStreamPlayer
@onready var portrait_area: DialoguePortrait = $DialogueUI/PortraitArea
@onready var choice_options: VBoxContainer = $DialogueUI/VBoxContainer


# Outfit refs
@onready var underneath_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/00undr"
@onready var body_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/01body"
@onready var sock_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/02sock"
@onready var foot_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/03fot1"
@onready var legs_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/04lwr1"
@onready var shirt_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/05shrt"
@onready var overalls_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/06lwr2"
@onready var boots_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/07fot2"
@onready var skirt_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/08lwr3"
@onready var hands_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/09hand"
@onready var outerwear_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/10outr"
@onready var neck_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/11neck"
@onready var face_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/12face"
@onready var hair_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/13hair"
@onready var head_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/14head"
@onready var ears_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/14ears"
@onready var over_sprite: Sprite2D = $"DialogueUI/PortraitArea/Skeleton/15over"

## ----------- FUNCTIONS -----------

func _ready() -> void:
	load_palettes()
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	timer.timeout.connect(_on_timer_timeout)
	hide_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if(
		event.is_action_pressed("ui_interact") or
		event.is_action_pressed("ui_attack") or
		event.is_action_pressed("ui_accept")
	):
		if text_in_progress == true:
			content.visible_characters = text_length
			timer.stop()
			text_in_progress = false
			show_dialogue_progress_indicator(true)
			return
		elif waiting_for_choice == true:
			return
		advance_dialogue()

func advance_dialogue() -> void:
	dialogue_item_index += 1
	if dialogue_item_index < dialogue_items.size():
		start_dialogue()
	else:
		hide_dialogue()
	pass

# Shows the Dialogue UI
func show_dialogue(_items : Array[DialogueItem]) -> void:
	is_active = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogue_items = _items
	dialogue_item_index = 0
	GlobalPlayerManager.player.update_animation("idle")
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = true
	await get_tree().process_frame
	if dialogue_items.size() == 0:
		hide_dialogue()
	else:
		start_dialogue()
	pass

func hide_dialogue() -> void:
	is_active = false
	choice_options.visible = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass

# Starts the dialogue
func start_dialogue() -> void:
	waiting_for_choice = false
	show_dialogue_progress_indicator(false)
	var _d: DialogueItem = dialogue_items[dialogue_item_index]
	
	if _d is DialogueText:
		set_dialogue_text(_d as DialogueText)
	elif _d is DialogueChoice:
		set_dialogue_choice(_d as DialogueChoice)
	
	#set_dialogue_data(_d)


func set_dialogue_text(_d : DialogueText) -> void:
	content.text = _d.text
	choice_options.visible = false
	name_label.text = _d.npc_info.npc_name
	pronouns_label.text = _d.npc_info.npc_pronouns
	portrait_area.audio_pitch_base = _d.npc_info.dialogue_audio_pitch
	set_npc_appearance(_d)
	var npc_pose = _d.pose
	var npc_pose_two = _d.pose_two
	#var loop_wait = _d.loop_period
	dialogue_animation.play(npc_pose)
	if npc_pose_two:
		dialogue_animation.play(npc_pose)
		await dialogue_animation.animation_finished
		dialogue_animation.play(npc_pose_two)
	
	content.visible_characters = 0
	text_length = content.get_total_character_count()
	plain_text = content.get_parsed_text()
	text_in_progress = true
	start_timer()


func set_dialogue_choice(_d : DialogueChoice) -> void:
	choice_options.visible = true
	waiting_for_choice = true
	
	for c in choice_options.get_children():
		c.queue_free()
	
	for i in _d.dialogue_branches.size():
		var _new_choice : Button = Button.new()
		_new_choice.text = _d.dialogue_branches[i].text
		_new_choice.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_new_choice.pressed.connect(_dialogue_choice_selected.bind(_d.dialogue_branches[i]))
		choice_options.add_child(_new_choice)
	
	if Engine.is_editor_hint():
		return
	
	await get_tree().process_frame
	await get_tree().process_frame
	choice_options.get_child(0).grab_focus()


func _dialogue_choice_selected(_d : DialogueBranch) -> void:
	choice_options.visible = false
	show_dialogue(_d.dialogue_items)
	pass


func _on_timer_timeout() -> void:
	content.visible_characters += 1
	start_timer()
	if content.visible_characters <= text_length:
		letter_added.emit(plain_text[content.visible_characters -1])
		start_timer()
	else:
		show_dialogue_progress_indicator(true)
		text_in_progress = false


func start_timer() -> void:
	timer.wait_time = text_speed
	#var _char = plain_text[content.visible_characters -1]
	#if '.!?:;'.contains(_char):
	#	timer.wait_time *= 4
	#elif ','.contains(_char):
	#	timer.wait_time *= 2
	timer.start()

func show_dialogue_progress_indicator(_is_visible : bool) -> void:
	dialogue_progress_indicator.visible = _is_visible
	if dialogue_item_index + 1 < dialogue_items.size():
		dialogue_progress_indicator_label.text = "NEXT"
	else:
		dialogue_progress_indicator_label.text = "END"


## ------------------- NPC PORTRAITS --------------------
var palettes
var body_layer = get_node_or_null("CharacterCreator/skeleton/01body")
var farmer_base_path = "res://assets/character/"

func set_npc_appearance(_d : DialogueItem) -> void:
	if _d.npc_info:
		if body_sprite:
			body_sprite.texture = _d.npc_info.npc_body
			body_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][_d.npc_info.npc_skin_colour])
		if underneath_sprite:
			underneath_sprite.texture = _d.npc_info.npc_underneath
			underneath_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][_d.npc_info.npc_underneath_colour])
		if sock_sprite:
			sock_sprite.texture = _d.npc_info.npc_sock
			sock_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_sock_colour])
		if foot_sprite:
			foot_sprite.texture = _d.npc_info.npc_foot
			foot_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_foot_colour])
		if legs_sprite:
			legs_sprite.texture = _d.npc_info.npc_legs
			legs_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_legs_colour])
		if shirt_sprite:
			shirt_sprite.texture = _d.npc_info.npc_shirt
			shirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_shirt_colour])
		if overalls_sprite:
			overalls_sprite.texture = _d.npc_info.npc_overalls
			overalls_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_overalls_colour])
		if boots_sprite:
			boots_sprite.texture = _d.npc_info.npc_boots
			boots_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_boots_colour])
		if skirt_sprite:
			skirt_sprite.texture = _d.npc_info.npc_skirt
			skirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_skirt_colour])
		if hands_sprite:
			hands_sprite.texture = _d.npc_info.npc_hands
			hands_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_hands_colour])
		if outerwear_sprite:
			outerwear_sprite.texture = _d.npc_info.npc_outerwear
			outerwear_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_outerwear_colour])
		if neck_sprite:
			neck_sprite.texture = _d.npc_info.npc_neck
			neck_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][_d.npc_info.npc_neck_colour])
		if face_sprite:
			face_sprite.texture = _d.npc_info.npc_face
			face_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_face_colour])
		if hair_sprite:
			hair_sprite.texture = _d.npc_info.npc_hair
			hair_sprite.material = get_palette_shader(palettes["haircolor"]["base"], palettes["haircolor"]["palettes"][_d.npc_info.npc_hair_colour])
		if head_sprite:
			head_sprite.texture = _d.npc_info.npc_head
			head_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][_d.npc_info.npc_head_colour])
		if ears_sprite:
			ears_sprite.texture = _d.npc_info.npc_ears
			ears_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][_d.npc_info.npc_skin_colour])
		if over_sprite:
			over_sprite.texture = _d.npc_info.npc_over
			over_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][_d.npc_info.npc_over_colour])

func load_palettes():
	palettes = {
			"skincolor": {
				"base_file": farmer_base_path+"palettes/base ramps/skin color base ramp.png",
				"file": farmer_base_path+"palettes/mana seed skin ramps.png",
				"base": farmer_base_path+"palettes/base ramps/skin color base ramp.png",
				"palettes": farmer_base_path+"palettes/mana seed skin ramps.png",
			},
			"haircolor": {
				"base_file": farmer_base_path+"palettes/base ramps/hair color base ramp.png",
				"file": farmer_base_path+"palettes/mana seed hair ramps.png",
				"base": farmer_base_path+"palettes/base ramps/hair color base ramp.png",
				"palettes": farmer_base_path+"palettes/mana seed hair ramps.png",
			},
			"3color": {
				"base_file": farmer_base_path+"palettes/base ramps/3-color base ramp (00a).png",
				"file": farmer_base_path+"palettes/mana seed 3-color ramps.png",
				"base": farmer_base_path+"palettes/base ramps/3-color base ramp (00a).png",
				"palettes": farmer_base_path+"palettes/mana seed 3-color ramps.png",
			},
			"4color": {
				"base_file": farmer_base_path+"palettes/base ramps/4-color base ramp (00b).png",
				"file": farmer_base_path+"palettes/mana seed 4-color ramps.png",
				"base": null,
				"palettes": null
			},
		}
	for bp in palettes.values():
		# the colors of the base textures are extracted
		var base_texture = load(bp["base_file"])
		# the color swapper in the msca has a function that can get the colors out of an image
		bp["base"] = MSCAPaletteSwaps.create_palette_from_image(base_texture.get_image())
		if bp["file"] != "":
			# for the other palettes
			bp["palettes"] = []
			var _palettes = load(bp["file"])
			# the whole image is loaded
			var palettes_image = _palettes.get_image()
			# then the amount of palettes in this image is calculated (each palette is 2px high)
			var palettes_count = palettes_image.get_height()/2
			# for each of this palettes
			for p in palettes_count:
				var start_y = p*2
				# a palette image is cut out
				var palette_image = palettes_image.get_region(Rect2i(0,start_y,palettes_image.get_width(),2))
				# and the palette is extracted with the swapper
				var new_palette = MSCAPaletteSwaps.create_palette_from_image(palette_image)
				# if there are colors in the palette (to not add the empty rows) it is added to the array of possible palettes
				if new_palette.size() > 0: bp["palettes"].append(new_palette)
				# even if i store these palettes here in this array, when i save the informations for the playe or items,
				# the actual color values are saved not the position in the palette array, so even if the base image changes
				# the colors of already existend objects will stay the same

func get_palette_shader(original_palette:Array = [], palette_to_set:Array = []) -> ShaderMaterial:
	# only create a shader material when the palette-sizes are > 0
	if original_palette.size() > 0 && palette_to_set.size() > 0 && original_palette.size() == palette_to_set.size():
		# create a new shader material
		var shader_material = ShaderMaterial.new()
		# set the shader to the loaded shader
		shader_material.shader = shader
		var p_count = 0
		# for each color in the palette to set, set two shader parameters: the original color and the replacement color
		for p in palette_to_set:
			shader_material.set_shader_parameter("original_"+str(p_count),original_palette[p_count])
			shader_material.set_shader_parameter("replace_"+str(p_count),p)
			p_count = p_count +1
		return shader_material
	return null
