### Player.gd

class_name Player extends CharacterBody2D

# Node Refs;
@onready var animation_player : AnimationPlayer = $Skeleton/AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $Effects/EffectAnimationPlayer
@onready var sprite = $Skeleton
@onready var ray_cast = $RayCast2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var name_label = $"Skeleton/Name"
@onready var hit_box : HitBox = $HitBox
@onready var audio: AudioStreamPlayer2D = $Effects/AudioStreamPlayer2D


# Outfit refs
@onready var shadow = $"Skeleton/shadow"
@onready var underneath = $"Skeleton/00undr"
@onready var body = $"Skeleton/01body"
@onready var sock = $"Skeleton/02sock"
@onready var foot = $"Skeleton/03fot1"
@onready var legs = $"Skeleton/04lwr1"
@onready var shirt = $"Skeleton/05shrt"
@onready var overalls = $"Skeleton/06lwr2"
@onready var boots = $"Skeleton/07fot2"
@onready var skirt = $"Skeleton/08lwr3"
@onready var hands = $"Skeleton/09hand"
@onready var outerwear = $"Skeleton/10outr"
@onready var neck = $"Skeleton/11neck"
@onready var face = $"Skeleton/12face"
@onready var hair = $"Skeleton/13hair"
@onready var head = $"Skeleton/14head"
@onready var over = $"Skeleton/15over"
@onready var thirtytwo = $"Skeleton/32x32_anims"

# Signals
signal direction_changed( new_direction:Vector2 )
signal player_damaged( hurt_box: HurtBox )


var invulnerable : bool = false
var health : int = 6
var max_health : int = 6

 # Player Movement

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction : Vector2 = Vector2.ZERO

var is_attacking = false
var is_sprinting = false
var can_move = true

#direction and animation to be updated throughout game state
var new_direction = Vector2(0,1) #only move one spaces
var animation

func _ready():
	state_machine.initialize(self)
	GlobalPlayerManager.player = self
	hit_box.damaged.connect( _take_damage )
	update_health(99)
	#initialize_player()

## ---------------------- MOVEMENT & ANIMATIONS ---------------------

func _process(_delta):
	# Get player input (left, right, up/down)
	#direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = Vector2( Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down") ).normalized()


func _physics_process(_delta):
	move_and_slide()

# Animation Direction
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( (direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size() ))
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	return true

func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"

# --------------------- DAMAGE ----------

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
		
	if health > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_health(99)
	update_health(-hurt_box.damage)

func update_health(delta : int) -> void:
	health = clampi(health + delta, 0, max_health)
	PlayerHUD.update_health(health, max_health)

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true

# --------------------- PLAYER DESIGN ----------

func initialize_player():
	
	# Underneath and color
	underneath.texture = Global.underneath_collection[Global.selected_underneath]
	underneath.material = Global.selected_underneath_color
	
	# Body and color
	body.texture = Global.body_collection[Global.selected_body]
	body.material = Global.selected_body_color
	
	# sock and color
	sock.texture = Global.sock_collection[Global.selected_sock]
	sock.material = Global.selected_sock_color
	
	# foot and color
	foot.texture = Global.foot_collection[Global.selected_foot]
	foot.material = Global.selected_foot_color
	
	# legs and color
	legs.texture = Global.legs_collection[Global.selected_legs]
	legs.material = Global.selected_legs_color
	
	# shirt and color
	shirt.texture = Global.shirt_collection[Global.selected_shirt]
	shirt.material = Global.selected_shirt_color
	
	# overalls and color
	overalls.texture = Global.overalls_collection[Global.selected_overalls]
	overalls.material = Global.selected_overalls_color
	
	# boots and color
	boots.texture = Global.boots_collection[Global.selected_boots]
	boots.material = Global.selected_boots_color
	
	# skirt and color
	skirt.texture = Global.skirt_collection[Global.selected_skirt]
	skirt.material = Global.selected_skirt_color
	
	# hands and color
	hands.texture = Global.hands_collection[Global.selected_hands]
	hands.material = Global.selected_hands_color
	
	# outerwear and color
	outerwear.texture = Global.outerwear_collection[Global.selected_outerwear]
	outerwear.material = Global.selected_outerwear_color
	
	# neck and color
	neck.texture = Global.neck_collection[Global.selected_neck]
	neck.material = Global.selected_neck_color
	
	# face and color
	face.texture = Global.face_collection[Global.selected_face]
	face.material = Global.selected_face_color
	
	# Hair and color
	hair.texture = Global.hair_collection[Global.selected_hair]
	hair.material = Global.selected_hair_color
	
	# head and color
	head.texture = Global.head_collection[Global.selected_head]
	head.material = Global.selected_head_color
	
	# over and color
	over.texture = Global.over_collection[Global.selected_over]
	over.material = Global.selected_over_color
	
	# Player name
	name_label.text = Global.player_name

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false

# --------------------- QUESTS ----------
