## 10outr.gd

extends Node2D

# Node ref
@onready var outerwear_sprite = $Sprite2D
var shader = preload("res://Globals/Shaders/palette_swaps.gdshader")

# store the palettes you want to use
var palettes
var body_layer = get_node_or_null("CharacterCreator/Skeleton/01body")
var farmer_base_path = "res://Assets/Character/"

# Keys
var outerwear_keys = []
var current_outerwear_index = 0
var singlethreecolours: int = 0
var rng_colors = RandomNumberGenerator.new()
var rng_sprite = RandomNumberGenerator.new()

func _ready():
	set_sprite_keys()
	update_sprite()
	load_palettes()
	
# Set keys
func set_sprite_keys():
	outerwear_keys = Global.outerwear_collection.keys()

# Updates texture & modulate
func update_sprite():
	var current_sprite = outerwear_keys[current_outerwear_index]	
	if current_sprite == "none":
		outerwear_sprite.texture = null
		outerwear_sprite.material = null
	else:
		outerwear_sprite.texture = Global.outerwear_collection[current_sprite]
		outerwear_sprite.material = get_palette_shader(palettes["3color"]["base"], palettes["3color"]["palettes"][singlethreecolours])
	
	Global.selected_outerwear = current_sprite
	Global.selected_outerwear_color = outerwear_sprite.material

# in my game i load all the palettes like this (next to the 3 and 4 ramps the hairs and body ramps too)
func load_palettes():
	# the palette informations contain the paths of the base ramps and the full set of ramps offered.
	palettes = {
			"3color": {
				"base_file": farmer_base_path+"Palettes/base ramps/3-color base ramp (00a).png",
				"file": farmer_base_path+"Palettes/mana seed 3-color ramps.png",
				"base": farmer_base_path+"Palettes/base ramps/3-color base ramp (00a).png",
				"palettes": farmer_base_path+"Palettes/mana seed 3-color ramps.png",
			},
			"4color": {
				"base_file": farmer_base_path+"Palettes/base ramps/4-color base ramp (00b).png",
				"file": farmer_base_path+"Palettes/mana seed 4-color ramps.png",
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

func _on_collection_button_pressed() -> void:
	current_outerwear_index = (current_outerwear_index + 1) % outerwear_keys.size()
	update_sprite()

func _on_color_button_pressed() -> void:
	singlethreecolours = (singlethreecolours + 1) % palettes["3color"]["palettes"].size()
	update_sprite()

func _on_random_button_pressed() -> void:
	current_outerwear_index = rng_sprite.randi_range(1, Global.outerwear_collection.size() - 1) % outerwear_keys.size()
	singlethreecolours = rng_colors.randi_range(1, palettes["3color"]["palettes"].size() - 1) % palettes["3color"]["palettes"].size()
	update_sprite()

func _on_color_back_button_pressed() -> void:
	singlethreecolours = (singlethreecolours - 1) % palettes["3color"]["palettes"].size()
	update_sprite()

func _on_collection_back_button_pressed() -> void:
	current_outerwear_index = (current_outerwear_index - 1) % outerwear_keys.size()
	update_sprite()
