## State_Stun.gd

class_name State_Stun extends State

# References
@onready var idle : State = $"../Idle"
@onready var death: State_Death = $"../Death"

# Variables
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

## ---------------------- FUNCTIONS ----------------

func init() -> void:
	player.player_damaged.connect(_player_damaged)

# What happens when the player enters this state?
func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	
	player.update_animation("hurt")
	player.make_invulnerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	
	GlobalPlayerManager.shake_camera(hurt_box.damage)

# What happens when the player exits this state?
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

func _player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	if state_machine.current_state != death:
		state_machine.change_state(self)
	

func _animation_finished(_a : String) -> void:
	next_state = idle
	if player.health <= 0:
		next_state = death
