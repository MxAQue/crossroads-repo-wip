## dark_wizard_boss.gd

class_name DarkWizardBoss extends Node2D

const ENERGY_EXPLOSION_SCENE : PackedScene = preload("res://opponents/abilities/energy_explosion.tscn")

@export var max_boss_health : int = 10
var boss_health : int = 10

var audio_hurt : AudioStream = preload("res://assets/audio/effects/boss_hurt.wav")

# Positions
var current_position : int = 0
var positions : Array[Vector2]
var beam_attacks : Array[EnergyBeamAttack]

# References:
@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: HitBox = $BossNode/HitBox

@onready var boss_light: PointLight2D = $BossNode/PointLight2D
@onready var audio: AudioStreamPlayer2D = $BossNode/AudioStreamPlayer2D

@onready var animation_player: AnimationPlayer = $BossNode/AnimationPlayer
@onready var damaged_animation: AnimationPlayer = $BossNode/DamagedAnimation
@onready var cloak_animation: AnimationPlayer = $BossNode/CloakSprite/CloakAnimation

@onready var hand_01: Sprite2D = $BossNode/CloakSprite/Hand01
@onready var hand_02: Sprite2D = $BossNode/CloakSprite/Hand02
@onready var hand_02_up: Sprite2D = $BossNode/CloakSprite/Hand02_UP
@onready var hand_01_up: Sprite2D = $BossNode/CloakSprite/Hand01_UP
@onready var hand_01_right: Sprite2D = $BossNode/CloakSprite/Hand01_RIGHT
@onready var hand_02_right: Sprite2D = $BossNode/CloakSprite/Hand02_RIGHT
@onready var hand_01_left: Sprite2D = $BossNode/CloakSprite/Hand01_LEFT
@onready var hand_02_left: Sprite2D = $BossNode/CloakSprite/Hand02_LEFT


## -------------------- FUNCTIONS ------------------

func _ready() -> void:
	
	# Boss Health
	boss_health = max_boss_health
	
	hit_box.damaged.connect(damage_taken)
	
	# PositionTargets locations
	for c in $PositionTargets.get_children():
		positions.append(c.global_position)
	print(positions)
	$PositionTargets.visible = false
	
	#Energy Beam Attacks
	for b in $BeamAttacks.get_children():
		beam_attacks.append(b)
	
	teleport(0)

func _process(_delta: float) -> void:
	hand_01_up.position = hand_02.position
	hand_01_up.frame = hand_01.frame + 4
	hand_02_up.position = hand_01.position
	hand_02_up.frame = hand_02.frame + 4
	hand_01_right.position = hand_01.position
	hand_01_right.frame = hand_01.frame + 8
	hand_02_right.position = hand_02.position
	hand_02_right.frame = hand_02.frame + 12
	hand_01_left.position = hand_01.position
	hand_01_left.frame = hand_01.frame + 12
	hand_02_left.position = hand_02.position
	hand_02_left.frame = hand_02.frame + 8
	pass

func teleport(_location : int) -> void:
	animation_player.play("disappear")
	enable_hit_boxes(false)
	#shoot fireball
	await get_tree().create_timer(1).timeout
	boss_node.global_position = positions[_location]
	current_position = _location
	update_animations()
	animation_player.play("appear")
	await animation_player.animation_finished
	idle()
	

func idle() -> void:
	enable_hit_boxes()
	animation_player.play("idle")
	await animation_player.animation_finished
	
	#Energy Beam Attack
	energy_beam_attack()
	animation_player.play("cast_spell")
	await animation_player.animation_finished
	
	# Teleport Again
	var _t : int = current_position
	while _t == current_position:
		_t = randi_range(0,3)
	#var _t = current_position + 1 /// transport in order
	if _t > 3:
		_t = 0
	teleport(_t)

func update_animations() -> void:
	
	hand_01.visible = false
	hand_02.visible = false
	hand_01_up.visible = false
	hand_02_up.visible = false
	hand_01_right.visible = false
	hand_02_right.visible = false
	hand_01_left.visible = false
	hand_02_left.visible = false
	
	if current_position == 0:
		cloak_animation.play("down")
		hand_01.visible = true
		hand_02.visible = true
	elif current_position == 2:
		cloak_animation.play("up")
		hand_01_up.visible = true
		hand_02_up.visible = true
	elif current_position == 1:
		cloak_animation.play("right")
		hand_01_right.visible = true
		hand_02_right.visible = true
	elif current_position == 3:
		cloak_animation.play("left")
		hand_01_left.visible = true
		hand_02_left.visible = true
		


func energy_beam_attack() -> void:
	var _b: Array[int]
	match current_position:
		0, 2:
			if current_position == 0:
				_b.append(0)
				_b.append(randi_range(1,2))
			else:
				_b.append(2)
				_b.append(randi_range(0,1))
			#scale with difficulty
	for b in _b:
		beam_attacks[b].attack()


func damage_taken(_hurt_box : HurtBox) -> void:
	if damaged_animation.current_animation == "damaged" or _hurt_box.damage == 0:
		return
	play_audio(audio_hurt)
	boss_health = clampi(boss_health - _hurt_box.damage, 0, max_boss_health)
	#update boss health bar
	damaged_animation.play("damaged")
	damaged_animation.seek(0)
	damaged_animation.queue("default")
	if boss_health == 0:
		defeat()

func play_audio( _a : AudioStream) -> void:
	audio.stream = _a
	audio.play()

func defeat() -> void:
	animation_player.play("destroy")
	enable_hit_boxes(false)
	persistent_data_handler.set_value()
	boss_light.visible = false
	await animation_player.animation_finished
	#reopen the room

func enable_hit_boxes(_v : bool = true) -> void:
	hit_box.set_deferred("monitorable", _v)
	hurt_box.set_deferred("monitoring", _v)

func explosion(_p : Vector2 = Vector2.ZERO) -> void:
	var e : Node2D = ENERGY_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred(e)
