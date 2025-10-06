## enemy_state_chase.gd

class_name EnemyStateChase extends EnemyState

const PATHFINDER : PackedScene = preload("res://opponents/pathfinder.tscn")

@export var anim_name : String = "chase"
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.25

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState

var pathfinder : Pathfinder

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false

### ------------------- FUNCTIONS -----------

func _ready():
	pass

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)

# What happens when the player enters this state?
func enter() -> void:
	pathfinder = PATHFINDER.instantiate() as Pathfinder
	enemy.add_child(pathfinder)
	_timer = state_aggro_duration
	enemy.update_animation(anim_name)
	if attack_area:
		attack_area.monitoring = true
	pass

# What happens when the player exits this state?
func exit() -> void:
	pathfinder.queue_free()
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	if GlobalPlayerManager.player.health <= 0:
		return next_state
	#var new_dir : Vector2 = enemy.global_position.direction_to(GlobalPlayerManager.player.global_position)
	#_direction = lerp(_direction, new_dir, turn_rate)
	
	_direction = lerp(_direction, pathfinder.move_dir, turn_rate)
	enemy.velocity = _direction * chase_speed
	
	if enemy.set_direction(_direction):
		enemy.update_animation(anim_name)
	if _can_see_player == false:
		_timer -= _delta
		if _timer < 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null

func _on_player_enter() -> void:
	_can_see_player = true
	if( 
		state_machine.current_state is EnemyStateStun
		or state_machine.current_state is EnemyStateDestroyed
	):
		return
	state_machine.change_state(self)

func _on_player_exit() -> void:
	_can_see_player = false
