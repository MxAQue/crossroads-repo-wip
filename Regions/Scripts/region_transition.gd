## region_transition.gd
@tool

class_name RegionTransition extends Area2D

signal entered_from_here

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export_file("*.tscn") var region
@export var target_transition_area : String = "RegionTransition"
@export var centre_player : bool = false

@export_category("Collision Area Settings")
@export_range(1,12,1, "or_greater") var size : int = 1 :
	set(_v):
		size = _v
		call_deferred("_update_area")
@export var side: SIDE = SIDE.LEFT
@export var snap_to_grid : bool = false:
	set (_v):
		call_deferred("_update_area")
		

## -------------- FUNCTIONS -------------

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player()
	
	await GlobalRegionManager.region_loaded
	
	# Some extra physics frame awaits will avoid issues related to frame rate
	# & physics process frame rate not syncing up... we had a bug where no matter
	# what we did the collision would still sometimes happen at the players
	# OLD position after loading on PC's running the game at 120 or 144fps
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	body_entered.connect(_player_entered)
	monitoring = true



func _player_entered(_p : Node2D) -> void:
	GlobalRegionManager.load_new_region(region,target_transition_area, get_offset())
	pass

func _place_player() -> void:
	if name != GlobalRegionManager.target_transition:
		return
	GlobalPlayerManager.set_player_position(global_position + GlobalRegionManager.position_offset)
	entered_from_here.emit()

func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = GlobalPlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		if centre_player == true:
			offset.y = 0
		else:
			offset.y = player_pos.y - global_position.y
		offset.x = 64
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		if centre_player == true:
			offset.x = 0
		else:
			offset.x = player_pos.x - global_position.x
		offset.y = 64
		if side == SIDE.TOP:
			offset.y *= -1
	return offset

func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 32, 32 )
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	
	#if collision_shape.shape is RectangleShape2D:
	#	var rect_shape :=collision_shape.shape as RectangleShape2D
	#	rect_shape.size = new_rect
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position

func _snap_to_grid() -> void:
	position.x = round(position.x / 16) * 16
	position.y = round(position.y / 16) * 16
