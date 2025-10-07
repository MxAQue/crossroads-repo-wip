## inventory_ui.gd

class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://gui/pause_menu/inventory/inventory_slot.tscn")

@onready var slot_weapon: InventorySlotUI = %SlotWeapon
@onready var slot_clothing: InventorySlotUI = %SlotClothing
@onready var slot_amulet: InventorySlotUI = %SlotAmulet
@onready var slot_ring: InventorySlotUI = %SlotRing


var focus_index : int = 0
@export var data : InventoryData

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)
	pass

func clear_inventory() -> void:
	for c in get_children():
		c.set_slot_data( null )

func update_inventory(apply_focus : bool = true) -> void:
	clear_inventory()
	
	var inventory_slots : Array[ SlotData ] = data.inventory_slots()
	
	#Inventory Slots
	for i in inventory_slots.size():
		var slot : InventorySlotUI = get_child( i )
		slot.set_slot_data( inventory_slots[ i ] )
		#connect_item_signals( slot )
	
	# Update equipment slots
	#var e_slots : Array[ SlotData ] = data.equipment_slots()
	#inventory_slot_armor.set_slot_data( e_slots[ 0 ] )
	#inventory_slot_weapon.set_slot_data( e_slots[ 1 ] )
	#inventory_slot_amulet.set_slot_data( e_slots[ 2 ] )
	#inventory_slot_ring.set_slot_data( e_slots[ 3 ] )
	
	if apply_focus:
		get_child(0).grab_focus()

func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return

func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory(i)
	
