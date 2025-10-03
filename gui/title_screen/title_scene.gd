## title_screen.gd
extends Node2D

const START_REGION : String = "res://regions/main.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_pressed_audio : AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var button_new: Button = $CanvasLayer/Control/VBoxContainer/ButtonNew
@onready var button_load: Button = $CanvasLayer/Control/VBoxContainer/ButtonLoad

## ----------------- FUNCTIONS ----------

func _ready() -> void:
	get_tree().paused = true
	GlobalPlayerManager.player.visible = false
	PlayerHUD.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if GlobalSaveManager.get_save_file() == null:
		button_load.disabled = true
		button_load.visible = false
	
	#$CanvasLayer/SplashScene.finished.connect( setup_title_screen() )
	setup_title_screen()
	GlobalRegionManager.region_load_started.connect(exit_title_screen)

func setup_title_screen() -> void:
	GlobalAudioManager.play_music(music)
	# New Game
	button_new.pressed.connect(start_game)
	button_new.grab_focus()
	button_new.focus_entered.connect(play_audio.bind(button_focus_audio))
	
	# Load Game
	button_load.pressed.connect(load_game)
	button_load.focus_entered.connect(play_audio.bind(button_focus_audio))
	

func start_game() -> void:
	play_audio(button_pressed_audio)
	GlobalRegionManager.load_new_region(START_REGION, "", Vector2.ZERO)
	pass

func load_game() -> void:
	play_audio(button_pressed_audio)
	GlobalSaveManager.load_game()

func exit_title_screen() -> void:
	GlobalPlayerManager.player.visible = true
	PlayerHUD.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	GlobalPlayerManager.player_spawned = false
	self.queue_free()

func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
