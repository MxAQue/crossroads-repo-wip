## equipable_item_modifier.gd

class_name EquipableItemModifier extends Resource

enum Type { HEALTH, ATTACK, DEFENCE, SPEED }
@export var type : Type = Type.HEALTH
@export var value : int = 1

### ------------------- FUNCTIONS --------------
