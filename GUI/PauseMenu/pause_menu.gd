## pause_menu.gd

extends CanvasLayer

signal shown
signal hidden

# Variables
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var button_save: Button = $Control/HBoxContainer/Button_Save
@onready var button_load: Button = $Control/HBoxContainer/Button_Load
@onready var item_description: Label = $Control/ItemDescription


var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
	get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	GlobalSaveManager.save_game()
	hide_pause_menu()
	print("game saved")

func _on_load_pressed() -> void:
	if is_paused == false:
		return
	GlobalSaveManager.load_game()
	await GlobalRegionManager.region_load_started
	hide_pause_menu()

func update_item_details(new_description : String) -> void:
	item_description. text = new_description

func play_audio(audio : AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
