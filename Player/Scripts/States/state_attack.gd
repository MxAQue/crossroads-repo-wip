## State_Attack.gd

class_name State_Attack extends State

# References
@onready var attack : State = $"../Attack"
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var charge_attack: Node = $"../ChargeAttack"


@onready var animation_player : AnimationPlayer = $"../../Skeleton/AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Effects/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5

var attacking : bool = false

# What happens when the player enters this state?
func enter() -> void:
	player.update_animation("strikefore")
	animation_player.animation_finished.connect(_end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	# 0.34 = third frame, 0.26 = second frame
	await get_tree().create_timer( 0.075).timeout
	if attacking:
		hurt_box.monitoring = true

# What happens when the player exits this state?
func exit() -> void:
	animation_player.animation_finished.disconnect(_end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	player.velocity = Vector2.ZERO
	#-= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null

# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	#if _event.is_action_pressed("ui_attack"):
	#	return attack
	return null

func _end_attack( _newAnimName : String) -> void:
	if Input.is_action_pressed("ui_attack"):
		state_machine.change_state(charge_attack)
	attacking = false
