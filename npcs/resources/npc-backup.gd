### npc.gd
@icon("res://assets/icons/dialogue/npc.svg")
@tool

extends CharacterBody2D

# Node ref
var shader = preload("res://globals/shaders/palette_swaps.gdshader")
@onready var animation: AnimationPlayer = $Skeleton/AnimationPlayer


# Signals
signal do_behaviour_enabled

# Variables
var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"

@export var npc_resource : NPCResource

@export_category("Appearance")
@export_range(0,17) var npc_skin_colour: int = 0
@export var npc_underneath: Texture2D
@export_range(0,47) var npc_underneath_colour: int = 0
@export var npc_sock: Texture2D
@export_range(0,47) var npc_sock_colour: int = 0
@export var npc_foot: Texture2D
@export_range(0,47) var npc_foot_colour: int = 0
@export var npc_legs: Texture2D
@export_range(0,47) var npc_legs_colour: int = 0
@export var npc_shirt: Texture2D
@export_range(0,47) var npc_shirt_colour: int = 0
@export var npc_overalls: Texture2D
@export_range(0,47) var npc_overalls_colour: int = 0
@export var npc_boots: Texture2D
@export_range(0,47) var npc_boots_colour: int = 0
@export var npc_skirt: Texture2D
@export_range(0,47) var npc_skirt_colour: int = 0
@export var npc_hands: Texture2D
@export_range(0,47) var npc_hands_colour: int = 0
@export var npc_outerwear: Texture2D
@export_range(0,47) var npc_outerwear_colour: int = 0
@export var npc_neck: Texture2D
@export_range(0,47) var npc_neck_colour: int = 0
@export var npc_face: Texture2D
@export_range(0,47) var npc_face_colour: int = 0
@export var npc_hair: Texture2D
@export_range(0,58) var npc_hair_colour: int = 0
@export var npc_head: Texture2D
@export_range(0,47) var npc_head_colour: int = 0
@export var npc_over: Texture2D
@export_range(0,47) var npc_over_colour: int = 0

# Outfit refs
@onready var underneath_sprite = $"Skeleton/00undr"
@onready var body_sprite = $"Skeleton/01body"
@onready var sock_sprite = $"Skeleton/02sock"
@onready var foot_sprite = $"Skeleton/03fot1"
@onready var legs_sprite = $"Skeleton/04lwr1"
@onready var shirt_sprite = $"Skeleton/05shrt"
@onready var overalls_sprite = $"Skeleton/06lwr2"
@onready var boots_sprite = $"Skeleton/07fot2"
@onready var skirt_sprite = $"Skeleton/08lwr3"
@onready var hands_sprite = $"Skeleton/09hand"
@onready var outerwear_sprite = $"Skeleton/10outr"
@onready var neck_sprite = $"Skeleton/11neck"
@onready var face_sprite = $"Skeleton/12face"
@onready var hair_sprite = $"Skeleton/13hair"
@onready var head_sprite = $"Skeleton/14head"
@onready var over_sprite = $"Skeleton/15over"
@onready var name_label = $"Skeleton/NPC_Name"


func _ready():
	load_palettes()
	# Show texture in game
	if not Engine.is_editor_hint():
		body_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][npc_skin_colour])
		underneath_sprite.texture = npc_underneath
		underneath_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_underneath_colour])
		sock_sprite.texture = npc_sock
		sock_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_sock_colour])
		foot_sprite.texture = npc_foot
		foot_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_foot_colour])
		legs_sprite.texture = npc_legs
		legs_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_legs_colour])
		shirt_sprite.texture = npc_shirt
		shirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_shirt_colour])
		overalls_sprite.texture = npc_overalls
		overalls_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_overalls_colour])
		boots_sprite.texture = npc_boots
		boots_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_boots_colour])
		skirt_sprite.texture = npc_skirt
		skirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_skirt_colour])
		hands_sprite.texture = npc_hands
		hands_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_hands_colour])
		outerwear_sprite.texture = npc_outerwear
		outerwear_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_outerwear_colour])
		neck_sprite.texture = npc_neck
		neck_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_neck_colour])
		face_sprite.texture = npc_face
		face_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_face_colour])
		hair_sprite.texture = npc_hair
		hair_sprite.material = get_palette_shader(palettes["haircolor"]["base"], palettes["haircolor"]["palettes"][npc_hair_colour])
		head_sprite.texture = npc_head
		head_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_head_colour])
		over_sprite.texture = npc_over
		over_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_over_colour])

func setup_npc() -> void:
	if npc_resource:
		#put texture stuff here later
		pass

func _process(_delta):
	# Show texture in engine
	if Engine.is_editor_hint():
		body_sprite.material = get_palette_shader(palettes["skincolor"]["base"], palettes["skincolor"]["palettes"][npc_skin_colour])
		underneath_sprite.texture = npc_underneath
		underneath_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_underneath_colour])
		sock_sprite.texture = npc_sock
		sock_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_sock_colour])
		foot_sprite.texture = npc_foot
		foot_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_foot_colour])
		legs_sprite.texture = npc_legs
		legs_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_legs_colour])
		shirt_sprite.texture = npc_shirt
		shirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_shirt_colour])
		overalls_sprite.texture = npc_overalls
		overalls_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_overalls_colour])
		boots_sprite.texture = npc_boots
		boots_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_boots_colour])
		skirt_sprite.texture = npc_skirt
		skirt_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_skirt_colour])
		hands_sprite.texture = npc_hands
		hands_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_hands_colour])
		outerwear_sprite.texture = npc_outerwear
		outerwear_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_outerwear_colour])
		neck_sprite.texture = npc_neck
		neck_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_neck_colour])
		face_sprite.texture = npc_face
		face_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_face_colour])
		hair_sprite.texture = npc_hair
		hair_sprite.material = get_palette_shader(palettes["haircolor"]["base"], palettes["haircolor"]["palettes"][npc_hair_colour])
		head_sprite.texture = npc_head
		head_sprite.material = get_palette_shader(palettes["4color"]["base"], palettes["4color"]["palettes"][npc_head_colour])
		over_sprite.texture = npc_over
		over_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][npc_over_colour])

# ------------------ PALETTES & OUTFITS ---------------

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
