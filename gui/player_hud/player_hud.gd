## player_hud.gd

extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://assets/audio/ui/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://assets/audio/ui/menu_select.wav")

var hearts : Array[HeartGUI] = []

@onready var game_over: Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var notifications: NotificationUI = $Control/Notifications


#BossBar
@onready var boss_ui: Control = $Control/BossUI
@onready var boss_progress_bar: TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label: Label = $Control/BossUI/Label


func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append (child)
			child.visible = false
	hide_game_over_screen()
	continue_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	continue_button.pressed.connect(load_game)
	title_button.focus_entered.connect(play_audio.bind(button_focus_audio))
	title_button.pressed.connect(title_screen)
	GlobalRegionManager.region_load_started.connect(hide_game_over_screen)
	
	hide_boss_health()

func update_health(_health : int, _max_health:int) -> void:
	update_max_health(_max_health)
	for i in _max_health:
		update_heart(i, _health)
	pass

func update_heart (_index : int, _health : int) -> void:
	var _value : int = clampi(_health - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_health(_max_health:int) -> void:
	var _heart_count : int = roundi(_max_health * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass

func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = GlobalSaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	if can_continue == true:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()

func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color(1,1,1,0)

func load_game() -> void:
	play_audio(button_select_audio)
	await fade_out()
	GlobalSaveManager.load_game()

func title_screen() -> void:
	play_audio(button_select_audio)
	await fade_out()
	GlobalRegionManager.load_new_region("res://gui/title_screen/title_scene.tscn", "", Vector2.ZERO)

func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	GlobalPlayerManager.player.revive_player() #un-dead the player
	return true

func play_audio(_a : AudioStream) -> void:
	audio.stream = _a
	audio.play()

func show_boss_health(boss_name : String) -> void:
	boss_ui.visible = true
	boss_label.text = boss_name
	update_boss_health(1,1)
	

func hide_boss_health() -> void:
	boss_ui.visible = false

func update_boss_health(boss_health : int, max_boss_health : int) -> void:
	boss_progress_bar.value = clampf( float(boss_health) / float(max_boss_health) * 100, 0, 100)

func queue_notification(_title : String, _message : String) -> void:
	notifications.add_notification_to_queue(_title, _message)
	pass
