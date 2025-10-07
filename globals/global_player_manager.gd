## GlobalPlayerManager.gd

extends Node

const PLAYER = preload("res://player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://gui/pause_menu/inventory/player_inventory.tres")

# Signals
signal camera_shook(trauma : float)
signal interact_pressed
signal player_leveled_up

var player : Player
var player_node: Node = null
var player_spawned : bool = false
var interact_handled : bool = true

#var level_requirements = [0, 50, 100, 200, 400, 800, 1500, 3000, 6000, 12000, 25000]
var level_requirements = [0, 5, 10, 20, 25, 50]

### ----------------- FUNCTIONS ----------------

func _ready() -> void:
	add_player_instance()
	#await get_tree().create_timer(0.2).timeout
	#player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_health(health : int, max_health : int) -> void:
	player.max_health = max_health
	player.health = health
	player.update_health(0)

func reward_xp(_xp : int) -> void:
	player.xp += _xp
	check_for_level_advance()

func check_for_level_advance() -> void:
	if player.level >= level_requirements.size():
		return
	if player.xp >= level_requirements[player.level]:
		player.level += 1
		player.attack += 1
		player.defence += 1
		player_leveled_up.emit()
		check_for_level_advance()

func set_player_position(_new_pos : Vector2) -> void:
	player.global_position = _new_pos

func set_as_parent(_p : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)

func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)

func play_audio(_audio : AudioStream) -> void:
	player.audio.stream = _audio
	player.audio.play()

func interact() -> void:
	interact_handled = false
	interact_pressed.emit()

func shake_camera(trauma : float = 1) -> void:
	camera_shook.emit(clampf(trauma, 0, 3))
	
