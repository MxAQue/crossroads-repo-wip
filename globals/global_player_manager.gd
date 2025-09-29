## GlobalPlayerManager.gd

extends Node

const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/PauseMenu/Inventory/player_inventory.tres")

signal interact_pressed

var player : Player
var player_node: Node = null
var player_spawned : bool = false
var interact_handled : bool = true

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
