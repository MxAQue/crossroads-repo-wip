## state_death.gd

class_name State_Death extends State

@export var exhaust_audio : AudioStream
@onready var audio : AudioStreamPlayer2D = $"../../Effects/AudioStreamPlayer2D"

## ---------------- FUNCTIONS -------------------

func init() -> void:
	pass

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("death")
	audio.stream = exhaust_audio
	audio.play()
	PlayerHUD.show_game_over_screen()
	GlobalAudioManager.play_music(null) #cuts out music/sets up death music
	pass

# What happens when the player exits this state?
func exit() -> void:
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	return null
