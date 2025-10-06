## pushable_crate.gd

class_name PushableCrate extends RigidBody2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_data_handler: PersistentDataHandler = $OnTarget


@export var persistent : bool = false
@export var persistent_location : Vector2 = Vector2.ZERO
@export var target_location_size : Vector2 = Vector2(3,3)

@export var push_speed : float = 30.0
var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var on_target : bool = false

# ------ Functions:

func _ready() -> void:
	if persistent_data_handler.value == true:
		position = persistent_location
	pass


func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * push_speed
	if persistent:
		var x_is_on : bool = abs(position.x - persistent_location.x) < 8 + target_location_size.x
		var y_is_on : bool = abs(position.y - persistent_location.y) < 4 + target_location_size.y
		if x_is_on and y_is_on and on_target == false:
			on_target = true
			persistent_data_handler.set_value()
		elif (x_is_on == false or y_is_on == false) and on_target == true:
			on_target = false
			persistent_data_handler.remove_value()
			


func _set_push(value:Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
