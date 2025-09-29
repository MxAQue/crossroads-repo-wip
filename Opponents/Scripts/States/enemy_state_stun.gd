## enemy_state_stun.gd

class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

func _ready():
	pass

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged)
	pass

# What happens when the player enters this state?
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	# Knockback
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	# Animation
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass

# What happens when the player exits this state?s
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null

func _on_enemy_damaged(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
