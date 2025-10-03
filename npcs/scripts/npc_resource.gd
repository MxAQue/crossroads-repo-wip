## npc_resource.gd

class_name NPCResource extends Resource

@export var npc_name : String = ""
@export var npc_pronouns : String = ""

@export_range(0.5,1.8,0.02) var dialogue_audio_pitch : float = 1.0

@export_category("Body")
@export var npc_body: Texture2D = preload("res://assets/character/bases/01body/fbas_01body_human_00.png")
@export_range(0,17) var npc_skin_colour: int = 0
@export var npc_ears: Texture2D = preload("res://assets/character/bases/14ears/fbas_14head_elfears_00.png")
@export_range(0,17) var npc_ear_colour: int = 0
@export var npc_hair: Texture2D
@export_range(0,58) var npc_hair_colour: int = 0

@export_category("Feet")
@export var npc_underneath: Texture2D
@export_range(0,47) var npc_underneath_colour: int = 0
@export var npc_sock: Texture2D
@export_range(0,47) var npc_sock_colour: int = 0
@export var npc_foot: Texture2D
@export_range(0,47) var npc_foot_colour: int = 0
@export var npc_boots: Texture2D
@export_range(0,47) var npc_boots_colour: int = 0
@export_category("Legs")
@export var npc_legs: Texture2D
@export_range(0,47) var npc_legs_colour: int = 0
@export var npc_overalls: Texture2D
@export_range(0,47) var npc_overalls_colour: int = 0
@export var npc_skirt: Texture2D
@export_range(0,47) var npc_skirt_colour: int = 0
@export_category("Torso")
@export var npc_shirt: Texture2D
@export_range(0,47) var npc_shirt_colour: int = 0
@export var npc_hands: Texture2D
@export_range(0,47) var npc_hands_colour: int = 0
@export var npc_outerwear: Texture2D
@export_range(0,47) var npc_outerwear_colour: int = 0
@export_category("Head")
@export var npc_neck: Texture2D
@export_range(0,47) var npc_neck_colour: int = 0
@export var npc_face: Texture2D
@export_range(0,47) var npc_face_colour: int = 0
@export var npc_head: Texture2D
@export_range(0,47) var npc_head_colour: int = 0
@export var npc_over: Texture2D
@export_range(0,47) var npc_over_colour: int = 0
