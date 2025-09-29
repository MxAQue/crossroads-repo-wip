### Global.gd

extends Node

# Scene and node references
var player_node: Node = null

# very simple shader, provided by this plugin
var shader = preload("res://globals/shaders/palette_swaps.gdshader")

# store the palettes you want to use
var palettes
var body_layer = get_node_or_null("Player/Skeleton/01body")
var farmer_base_path = "assets/character/bases/01body/fbas_01body_human_00.png"

# Sets the player reference for inventory interactions
func set_player_reference(player):
	player_node = player

# ------------------------------ IVENTORY ----------------------------


# ------------------------------ OUTFITS ----------------------------

# in my game i load all the palettes like this (next to the 3 and 4 ramps the hairs and body ramps too)
func load_palettes():
	# the palette informations contain the paths of the base ramps and the full set of ramps offered.
	palettes = {
			"3color": {
				"base_file": farmer_base_path+"Assets/Character/Palettes/base ramps/3-color base ramp (00a).png",
				"file": farmer_base_path+"Assets/Character/Palettes/mana seed 3-color ramps.png",
				"base": null,
				"palettes": null
			},
			"4color": {
				"base_file": farmer_base_path+"Assets/Character/Palettes/base ramps/4-color base ramp (00b).png",
				"file": farmer_base_path+"Assets/Character/Palettes/mana seed 4-color ramps.png",
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

# the coloring of the different layers is done with a shade wich is also included in the msca
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

# Collection of 00undr sprites
var underneath_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/00undr/fbas_00undr_cloakplain_00d.png"),
	"02" : preload("res://assets/character/bases/00undr/fbas_00undr_cloakwithmantleplain_00b.png")
}

# Collection of 01body sprites
var body_collection = {
	"01" : preload("res://assets/character/bases/01body/fbas_01body_human_00.png")
}

# Collection of 02sock sprites
var sock_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/02sock/fbas_02sock_sockshigh_00a.png"),
	"02" : preload("res://assets/character/bases/02sock/fbas_02sock_sockslow_00a.png"),
	"03" : preload("res://assets/character/bases/02sock/fbas_02sock_stockings_00a.png")
}

# Collection of 03fot1 small footwear sprites
var foot_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/03fot1/fbas_03fot1_boots_00a.png"),
	"02" : preload("res://assets/character/bases/03fot1/fbas_03fot1_sandals_00a.png"),
	"03" : preload("res://assets/character/bases/03fot1/fbas_03fot1_shoes_00a.png")
}

# Collection of 04lwr1 legwear sprites
var legs_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/04lwr1/fbas_04lwr1_longpants_00a.png"),
	"02" : preload("res://assets/character/bases/04lwr1/fbas_04lwr1_onepiece_00a.png"),
	"03" : preload("res://assets/character/bases/04lwr1/fbas_04lwr1_onepieceboobs_00a.png"),
	"04" : preload("res://assets/character/bases/04lwr1/fbas_04lwr1_shorts_00a.png"),
	"05" : preload("res://assets/character/bases/04lwr1/fbas_04lwr1_undies_00a.png")
}

# Collection of 05shrt sprites
var shirt_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/05shrt/fbas_05shrt_bra_00a.png"),
	"02" : preload("res://assets/character/bases/05shrt/fbas_05shrt_tanktop_00a.png"),
	"03" : preload("res://assets/character/bases/05shrt/fbas_05shrt_tanktopboobs_00a.png"),
	"04" : preload("res://assets/character/bases/05shrt/fbas_05shrt_shortshirt_00a.png"),
	"05" : preload("res://assets/character/bases/05shrt/fbas_05shrt_shortshirtboobs_00a.png"),
	"06" : preload("res://assets/character/bases/05shrt/fbas_05shrt_longshirt_00a.png"),
	"07" : preload("res://assets/character/bases/05shrt/fbas_05shrt_longshirtboobs_00a.png")
}

# Collection of 06lwr2 legwear extended sprites
var overalls_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/06lwr2/fbas_06lwr2_shortalls_00a.png"),
	"02" : preload("res://assets/character/bases/06lwr2/fbas_06lwr2_shortallsboobs_00a.png"),
	"03" : preload("res://assets/character/bases/06lwr2/fbas_06lwr2_overalls_00a.png"),
	"04" : preload("res://assets/character/bases/06lwr2/fbas_06lwr2_overallsboobs_00a.png")
}

# Collection of 07fot2 boots sprites
var boots_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/07fot2/fbas_07fot2_cuffedboots_00a.png"),
	"02" : preload("res://assets/character/bases/07fot2/fbas_07fot2_curlytoeshoes_00a.png")
}

# Collection of 08lwr3 dresses sprites
var skirt_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_frillyskirt_00a.png"),
	"02" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_frillydress_00a.png"),
	"03" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_frillydressboobs_00a.png"),
	"04" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_longskirt_00a.png"),
	"05" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_longdress_00a.png"),
	"06" : preload("res://assets/character/bases/08lwr3/fbas_08lwr3_longdressboobs_00a.png")
}

# Collection of 09hand sprites
var hands_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/09hand/fbas_09hand_gloves_00a.png")
}

# Collection of 10outr sprites
var outerwear_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/10outr/fbas_10outr_suspenders_00a.png"),
	"02" : preload("res://assets/character/bases/10outr/fbas_10outr_vest_00a.png")
}

# Collection of 11neck sprites
var neck_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/11neck/fbas_11neck_scarf_00b.png"),
	"02" : preload("res://assets/character/bases/11neck/fbas_11neck_mantleplain_00b.png"),
	"03" : preload("res://assets/character/bases/11neck/fbas_11neck_cloakplain_00d.png"),
	"04" : preload("res://assets/character/bases/11neck/fbas_11neck_cloakwithmantleplain_00b.png")
}

# Collection of 12face sprites
var face_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/12face/fbas_12face_glasses_00a.png"),
	"02" : preload("res://assets/character/bases/12face/fbas_12face_shades_00a.png")
}

# Collection of 13hair sprites
var hair_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/13hair/fbas_13hair_afropuffs_00.png"),
	"02" : preload("res://assets/character/bases/13hair/fbas_13hair_afro_00.png"),
	"03" : preload("res://assets/character/bases/13hair/fbas_13hair_bob1_00.png"),
	"04" : preload("res://assets/character/bases/13hair/fbas_13hair_bob2_00.png"),
	"05" : preload("res://assets/character/bases/13hair/fbas_13hair_bushy_00.png"),
	"06" : preload("res://assets/character/bases/13hair/fbas_13hair_dapper_00.png"),
	"07" : preload("res://assets/character/bases/13hair/fbas_13hair_flattop_00.png"),
	"08" : preload("res://assets/character/bases/13hair/fbas_13hair_longwavy_00.png"),
	"09" : preload("res://assets/character/bases/13hair/fbas_13hair_mohawk_00_e.png"),
	"10" : preload("res://assets/character/bases/13hair/fbas_13hair_ponytail1_00.png"),
	"11" : preload("res://assets/character/bases/13hair/fbas_13hair_spiky1_00.png"),
	"12" : preload("res://assets/character/bases/13hair/fbas_13hair_spiky2_00.png"),
	"13" : preload("res://assets/character/bases/13hair/fbas_13hair_twintail_00.png"),
	"14" : preload("res://assets/character/bases/13hair/fbas_13hair_twists_00.png")
}

# Collection of 14head sprites
var head_collection = {
	"none" : null,
	"01" : preload("res://assets/character/bases/14head/fbas_14head_bandana_00b_e.png"),
	"02" : preload("res://assets/character/bases/14head/fbas_14head_headscarf_00b_e.png"),
	"03" : preload("res://assets/character/bases/14head/fbas_14head_mushroom1_00d.png"),
	"04" : preload("res://assets/character/bases/14head/fbas_14head_boaterhat_01.png"),
	"05" : preload("res://assets/character/bases/14head/fbas_14head_boaterhat_00d.png"),
	"06" : preload("res://assets/character/bases/14head/fbas_14head_cowboyhat_01.png"),
	"07" : preload("res://assets/character/bases/14head/fbas_14head_cowboyhat_00d.png"),
	"08" : preload("res://assets/character/bases/14head/fbas_14head_floppyhat_01.png"),
	"09" : preload("res://assets/character/bases/14head/fbas_14head_floppyhat_00d.png"),
	"10" : preload("res://assets/character/bases/14head/fbas_14head_strawhat_01.png"),
	"11" : preload("res://assets/character/bases/14head/fbas_14head_strawhat_00d.png")
}

# Collection of 15over sprites
var over_collection = {
	"none" : null,
}

# Skintones
var body_color_options = [
	Color(1, 1, 1), # Default
	Color(0.96, 0.80, 0.69), # Light Skin
	Color(0.72, 0.54, 0.39), # Medium Skin
	Color(0.45, 0.34, 0.27), # Brown Skin
]

# Hair colos
var hair_color_options = [
	Color(1, 1, 1), # Default
	Color(0.1, 0.1, 0.1), # Black
	Color(0.4, 0.2, 0.1), # Brown
	Color(0.9, 0.6, 0.2), # Blonde
	Color(0.5, 0.25, 0), # Auburn
]

# Outfit & accessory colors
var color_options = [
	Color(1, 1, 1), # Default
	Color(1, 0, 0), # Red
	Color(0, 1, 0), # Green
	Color(0, 0, 1), # Blue
	Color(0, 0, 0), # Black
	Color(1, 1, 1), # White
]

# Selected values
var selected_underneath = ""
var selected_body = ""
var selected_sock = ""
var selected_foot = ""
var selected_legs = ""
var selected_shirt = ""
var selected_overalls = ""
var selected_boots = ""
var selected_skirt = ""
var selected_hands = ""
var selected_outerwear = ""
var selected_neck = ""
var selected_face = ""
var selected_hair = ""
var selected_head = ""
var selected_over = ""
var selected_underneath_color = ""
var selected_body_color = ""
var selected_sock_color = ""
var selected_foot_color = ""
var selected_legs_color = ""
var selected_shirt_color = ""
var selected_overalls_color = ""
var selected_boots_color = ""
var selected_skirt_color = ""
var selected_hands_color = ""
var selected_outerwear_color = ""
var selected_neck_color = ""
var selected_face_color = ""
var selected_hair_color = ""
var selected_head_color = ""
var selected_over_color = ""
var player_name = ""
