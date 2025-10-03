## state_lift.gd

class_name State_Lift extends State

@export var lift_audio : AudioStream
@onready var carry: State = $"../Carry"

## ---------------- FUNCTIONS -------------------

func _ready():
	pass

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("carry_lift")
	player.animation_player.animation_finished.connect(state_complete)
	player.audio.stream = lift_audio
	player.audio.play()

# What happens when the player exits this state?
func exit() -> void:
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	@warning_ignore("standalone_expression")
	player.velocity - Vector2.ZERO
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	return null

func state_complete(_a : String) -> void:
	player.animation_player.animation_finished.disconnect(state_complete)
	state_machine.change_state(carry)
	pass
