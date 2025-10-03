### npc.gd
@icon("res://assets/icons/dialogue/npc.svg")
@tool

class_name NPC extends CharacterBody2D

# Signals
signal do_behaviour_enabled

# Outfit refs
@onready var underneath_sprite = $"Skeleton/00undr"
@onready var body_sprite: Sprite2D = $"Skeleton/01body"
@onready var sock_sprite: Sprite2D = $"Skeleton/02sock"
@onready var foot_sprite: Sprite2D = $"Skeleton/03fot1"
@onready var legs_sprite: Sprite2D = $"Skeleton/04lwr1"
@onready var shirt_sprite: Sprite2D = $"Skeleton/05shrt"
@onready var overalls_sprite: Sprite2D = $"Skeleton/06lwr2"
@onready var boots_sprite: Sprite2D = $"Skeleton/07fot2"
@onready var skirt_sprite: Sprite2D = $"Skeleton/08lwr3"
@onready var hands_sprite: Sprite2D = $"Skeleton/09hand"
@onready var outerwear_sprite: Sprite2D = $"Skeleton/10outr"
@onready var neck_sprite: Sprite2D = $"Skeleton/11neck"
@onready var face_sprite: Sprite2D = $"Skeleton/12face"
@onready var hair_sprite: Sprite2D = $"Skeleton/13hair"
@onready var head_sprite: Sprite2D = $"Skeleton/14head"
@onready var ears_sprite: Sprite2D = $"Skeleton/14ears"
@onready var over_sprite: Sprite2D = $"Skeleton/15over"
@onready var name_label = $"Skeleton/NPC_Name"


# Node refs
var shader = preload("res://globals/shaders/palette_swaps.gdshader")
@onready var animation: AnimationPlayer = $Skeleton/AnimationPlayer

# Variables
var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"
var do_behaviour : bool = true


@export var npc_resource : NPCResource : set = _set_npc_resource


func _ready():
	load_palettes()
	setup_npc()
	if Engine.is_editor_hint():
		return
	gather_interactables()
	do_behaviour_enabled.emit()

func _physics_process(_delta: float) -> void:
	move_and_slide()

# Interactions

func gather_interactables() -> void:
	for c in get_children():
		if c is DialogueInteraction:
			c.player_interacted.connect(_on_player_interacted)
			c.finished.connect(_on_interaction_finished)

func _on_player_interacted() -> void:
	update_direction( GlobalPlayerManager.player.global_position )
	state = "idle"
	velocity = Vector2.ZERO
	update_animation()
	do_behaviour = false
	pass

func _on_interaction_finished() -> void:
	state = "idle"
	update_animation()
	do_behaviour = true
	do_behaviour_enabled.emit()
	pass

# Updates

func update_animation() -> void:
	animation.play(state + "_" + direction_name)

func update_direction(target_position : Vector2) -> void:
	direction = global_position.direction_to(target_position)
	update_direction_name()
	
func update_direction_name() -> void:
	var threshold : float = 0.45
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif direction.x > threshold:
		direction_name = "right"
	elif direction.x < -threshold:
		direction_name = "left"

func _set_npc_resource (_npc : NPCResource) -> void:
	npc_resource = _npc
	setup_npc()


# ------------------ PALETTES & OUTFITS ---------------

func setup_npc() -> void:
	if npc_resource:
		if body_sprite:
			body_sprite.texture = npc_resource.npc_body
			body_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][npc_resource.npc_skin_colour])
		if underneath_sprite:
			underneath_sprite.texture = npc_resource.npc_underneath
			underneath_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_resource.npc_underneath_colour])
		if sock_sprite:
			sock_sprite.texture = npc_resource.npc_sock
			sock_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_sock_colour])
		if foot_sprite:
			foot_sprite.texture = npc_resource.npc_foot
			foot_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_foot_colour])
		if legs_sprite:
			legs_sprite.texture = npc_resource.npc_legs
			legs_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_legs_colour])
		if shirt_sprite:
			shirt_sprite.texture = npc_resource.npc_shirt
			shirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_shirt_colour])
		if overalls_sprite:
			overalls_sprite.texture = npc_resource.npc_overalls
			overalls_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_overalls_colour])
		if boots_sprite:
			boots_sprite.texture = npc_resource.npc_boots
			boots_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_boots_colour])
		if skirt_sprite:
			skirt_sprite.texture = npc_resource.npc_skirt
			skirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_skirt_colour])
		if hands_sprite:
			hands_sprite.texture = npc_resource.npc_hands
			hands_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_hands_colour])
		if outerwear_sprite:
			outerwear_sprite.texture = npc_resource.npc_outerwear
			outerwear_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_outerwear_colour])
		if neck_sprite:
			neck_sprite.texture = npc_resource.npc_neck
			neck_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_resource.npc_neck_colour])
		if face_sprite:
			face_sprite.texture = npc_resource.npc_face
			face_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_face_colour])
		if hair_sprite:
			hair_sprite.texture = npc_resource.npc_hair
			hair_sprite.material = get_palette_shader(palettes["haircolor"]["base"], palettes["haircolor"]["palettes"][npc_resource.npc_hair_colour])
		if head_sprite:
			head_sprite.texture = npc_resource.npc_head
			head_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_resource.npc_head_colour])
		if ears_sprite:
			ears_sprite.texture = npc_resource.npc_ears
			ears_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][npc_resource.npc_skin_colour])
		if over_sprite:
			over_sprite.texture = npc_resource.npc_over
			over_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_resource.npc_over_colour])

# store the palettes you want to use
var palettes
var body_layer = get_node_or_null("CharacterCreator/skeleton/01body")
var farmer_base_path = "res://assets/character/"

# in my game i load all the palettes like this (next to the 3 and 4 ramps the hairs and body ramps too)
func load_palettes():
	# the palette informations contain the paths of the base ramps and the full set of ramps offered.
	palettes = {
			"skincolor": {
				"base_file": farmer_base_path+"palettes/base ramps/skin color base ramp.png",
				"file": farmer_base_path+"palettes/mana seed skin ramps.png",
				"base": farmer_base_path+"palettes/base ramps/skin color base ramp.png",
				"palettes": farmer_base_path+"palettes/mana seed skin ramps.png",
			},
			"haircolor": {
				"base_file": farmer_base_path+"palettes/base ramps/hair color base ramp.png",
				"file": farmer_base_path+"palettes/mana seed hair ramps.png",
				"base": farmer_base_path+"palettes/base ramps/hair color base ramp.png",
				"palettes": farmer_base_path+"palettes/mana seed hair ramps.png",
			},
			"3color": {
				"base_file": farmer_base_path+"palettes/base ramps/3-color base ramp (00a).png",
				"file": farmer_base_path+"palettes/mana seed 3-color ramps.png",
				"base": farmer_base_path+"palettes/base ramps/3-color base ramp (00a).png",
				"palettes": farmer_base_path+"palettes/mana seed 3-color ramps.png",
			},
			"4color": {
				"base_file": farmer_base_path+"palettes/base ramps/4-color base ramp (00b).png",
				"file": farmer_base_path+"palettes/mana seed 4-color ramps.png",
				"base": null,
				"palettes": null
			},
		}

# for each of the palette types defined above
	for bp in palettes.values():
		# the colors of the base textures are extracted
		var base_texture = load(bp["base_file"])
		# the color swapper in the msca has a function that can get the colors out of an image
		bp["base"] = MSCAPaletteSwaps.create_palette_from_image(base_texture.get_image())
		if bp["file"] != "":
			# for the other palettes
			bp["palettes"] = []
			var _palettes = load(bp["file"])
			# the whole image is loaded
			var palettes_image = _palettes.get_image()
			# then the amount of palettes in this image is calculated (each palette is 2px high)
			var palettes_count = palettes_image.get_height()/2
			# for each of this palettes
			for p in palettes_count:
				var start_y = p*2
				# a palette image is cut out
				var palette_image = palettes_image.get_region(Rect2i(0,start_y,palettes_image.get_width(),2))
				# and the palette is extracted with the swapper
				var new_palette = MSCAPaletteSwaps.create_palette_from_image(palette_image)
				# if there are colors in the palette (to not add the empty rows) it is added to the array of possible palettes
				if new_palette.size() > 0: bp["palettes"].append(new_palette)
				# even if i store these palettes here in this array, when i save the informations for the playe or items,
				# the actual color values are saved not the position in the palette array, so even if the base image changes
				# the colors of already existend objects will stay the same

# the coloring of the different layers is done with a shader which is also included in the msca
# this function creates the palette shader for a layer out of the original base palette and the new palette that the layer should have
func get_palette_shader(original_palette:Array = [], palette_to_set:Array = []) -> ShaderMaterial:
	# only create a shader material when the palette-sizes are > 0
	if original_palette.size() > 0 && palette_to_set.size() > 0 && original_palette.size() == palette_to_set.size():
		# create a new shader material
		var shader_material = ShaderMaterial.new()
		# set the shader to the loaded shader
		shader_material.shader = shader
		var p_count = 0
		# for each color in the palette to set, set two shader parameters: the original color and the replacement color
		for p in palette_to_set:
			shader_material.set_shader_parameter("original_"+str(p_count),original_palette[p_count])
			shader_material.set_shader_parameter("replace_"+str(p_count),p)
			p_count = p_count +1
		return shader_material
	return null

# ------------------ DIALOGUE & QUESTS ---------------


# ------------------ OTHER ---------------

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass # Replace with function body.
