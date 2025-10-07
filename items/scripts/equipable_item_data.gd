## equipable_item_data.gd

class_name EquipableItemData extends ItemData

enum Type {TOOL, WEAPON, CLOTHING, ARMOUR, AMULET, RING}
@export var type : Type = Type.TOOL
@export var modifiers : Array[EquipableItemModifier]

### ------------------- FUNCTIONS --------------------
