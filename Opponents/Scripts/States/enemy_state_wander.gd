## enemy_state_wander.gd

class_name EnemyStateWander extends EnemyState

@export var anim_name : String = "walk"
@export var wander_speed : float = 20.0

@export_category("AI")
@export var state_animation_duration : float = 1
@export var state_cycle_min : int = 1
@export var state_cycle_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2

func _ready():
	pass

func init() -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	_timer = randi_range(state_cycle_min, state_cycle_max) * state_animation_duration
	var rand = randi_range(0,3)
	_direction = enemy.DIR_4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction(_direction)
	enemy.update_animation(anim_name)
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null
