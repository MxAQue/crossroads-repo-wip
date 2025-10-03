## State_Idle.gd

class_name State_Idle extends State

# References
@onready var walk : State = $"../Walk"
@onready var attack : State = $"../Attack"

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("idle")
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("ui_attack"):
		return attack
	if _event.is_action_pressed("ui_interact"):
		GlobalPlayerManager.interact()
	return null
