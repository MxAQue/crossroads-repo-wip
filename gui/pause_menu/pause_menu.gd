## pause_menu.gd

extends CanvasLayer

signal shown
signal hidden

# Variables
@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_save: Button = $Control/TabContainer/System/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/TabContainer/System/VBoxContainer/Button_Load
@onready var button_quit: Button = $Control/TabContainer/System/VBoxContainer/Button_Quit

@onready var item_description: Label = $Control/TabContainer/Inventory/ItemDescription

@onready var tab_container: TabContainer = $Control/TabContainer


var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_quit.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		if is_paused == false:
			if DialogueSystem.is_active:
				return
			show_pause_menu()
		else:
			hide_pause_menu()
	if event.is_action_pressed("ui_quest_menu"):
		if is_paused == false:
			if DialogueSystem.is_active:
				return
			show_quest_menu()
		else:
			hide_pause_menu()
	get_viewport().set_input_as_handled()
	if is_paused:
		if event.is_action_pressed("ui_bump_right"):
			change_tab(1)
		elif event.is_action_pressed("ui_bump_left"):
			change_tab(-1)

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab = 0
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func show_quest_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	tab_container.current_tab = 1
	shown.emit()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	GlobalSaveManager.save_game()
	hide_pause_menu()

func _on_load_pressed() -> void:
	if is_paused == false:
		return
	GlobalSaveManager.load_game()
	await GlobalRegionManager.region_load_started
	hide_pause_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

func update_item_details(new_description : String) -> void:
	item_description. text = new_description

func play_audio(audio : AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

func change_tab(_i : int = 1) -> void:
	tab_container.current_tab = wrapi(
			tab_container.current_tab + _i,
			0,
			tab_container.get_tab_count()
	)
	tab_container.get_tab_bar().grab_focus()
	
