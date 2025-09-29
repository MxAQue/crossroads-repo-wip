## treasure_chest.gd

@tool

class_name TreasureChest extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity

var is_open : bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var is_opened: PersistentDataHandler = $IsOpen




func _ready() -> void:
	_update_texture()
	_update_label()
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	is_opened.data_loaded.connect( set_chest_state )
	set_chest_state()
	pass


func set_chest_state() -> void:
	is_open = is_opened.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")


func player_interact() -> void:
	if is_open == true:
		return
	is_open = true
	is_opened.set_value()
	animation_player.play("open_chest")
	print("chest opened")
	if item_data and quantity > 0:
		GlobalPlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	else:
		printerr("No Items in Chest!")
	pass


func _on_area_enter( _a : Area2D ) -> void:
	GlobalPlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	GlobalPlayerManager.interact_pressed.disconnect( player_interact )
	pass

# Item Data

func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()


func _set_quantity( value : int ) -> void:
	quantity = value
	_update_label()


func _update_texture() -> void:
	if sprite and item_data:
		sprite.texture = item_data.texture


func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )
