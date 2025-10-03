##sState_charge_attack.gd

class_name State_ChargeAttack extends State

# References
@export var charge_duration : float = 1.0
@export var move_speed : float = 80.0
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

@onready var animation_player : AnimationPlayer = $"../../Skeleton/AnimationPlayer"
@onready var attack : State = $"../Attack"
@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var audio_player : AudioStreamPlayer2D = $"../../Effects/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox
@onready var charge_hurt_box: HurtBox = %ChargeHurtBox
@onready var charge_spin_hurt_box: HurtBox = %ChargeSpinHurtBox
@onready var spin_effects_sprite: Sprite2D = $"../../Skeleton/spin_effects"
@onready var spin_animation_player: AnimationPlayer = $"../../Skeleton/spin_effects/SpinAnimationPlayer"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Skeleton/ChargeHurtBox/GPUParticles2D"


var particles : ParticleProcessMaterial
var is_attacking : bool = false
var walking : bool = false
var timer : float = 0.0

## ------------------ FUNCTIONS -----------


func init() -> void:
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	spin_effects_sprite.visible = false
	pass

# What happens when the player enters this state?
func enter() -> void:
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_hurt_box.monitoring = true
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 4
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30

# What happens when the player exits this state?
func exit() -> void:
	charge_hurt_box.monitoring = false
	charge_spin_hurt_box.monitoring = false
	spin_effects_sprite.visible = false
	gpu_particles_2d.emitting = false
	pass

# What happens during the _process update in this state?
func process( _delta: float ) -> State:
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
		
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.update_animation("charge_idle")
		elif player.set_direction() or walking == false:
			walking = true
			player.update_animation("charge_walk")
	player.velocity = player.direction * move_speed
	return null


# What happens during the _physics_process update in this state?
func physics( _delta: float ) -> State:
	return null


# What happens with input events in this state?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_released("ui_attack"):
		if timer > 0:
			return idle
		elif is_attacking == false:
			charge_attack()
	return null


func charge_attack() -> void:
	is_attacking = true
	
	player.animation_player.play("charge_attack")
	player.animation_player.seek( get_spin_frame() )
	
	play_audio(sfx_spin)
	spin_effects_sprite.visible = true
	spin_animation_player.play("spin")
	var _duration : float = player.animation_player.current_animation_length
	player.make_invulnerable(_duration)
	charge_spin_hurt_box.monitoring = true
	await get_tree().create_timer(_duration * 0.875).timeout
	state_machine.change_state( idle )
	pass

func get_spin_frame() -> float:
	var interval : float = 0.05
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.LEFT:
			return interval * 2
		Vector2.UP:
			return interval * 4
		Vector2.RIGHT:
			return interval * 6
		_:
			return interval * 6

func charge_complete() -> void:
	play_audio(sfx_charged)
	gpu_particles_2d.amount = 50
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	await get_tree().create_timer(0.5).timeout
	gpu_particles_2d.amount = 10
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30
	
	

func play_audio(_audio : AudioStream) -> void:
	audio_player.stream = _audio
	audio_player.play()
