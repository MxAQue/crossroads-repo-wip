## state_carry.gd

class_name State_Carry extends State

@export var move_speed : float = 100.0
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"
# drop state?

## ---------------- FUNCTIONS -------------------

func _ready():
	pass

func init() -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("carry_idle")
	walking = false
	pass

# What happens when the player exits this state?
func exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
			player.update_animation("carry_throw")
		else:
			throwable.throw_direction = player.direction
			player.update_animation("carry_throw")
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated(PI)
			throwable.drop()
			pass
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			print("throw")
			pass
		pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation("carry_idle")
	elif player.set_direction() or walking == false:
		player.update_animation("carry_walk")
		walking = true
	player.velocity = player.direction * move_speed
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("ui_attack"):
		return idle
	return null
