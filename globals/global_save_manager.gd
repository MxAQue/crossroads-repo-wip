## global_save_manager.gd

extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		level = 1,
		xp = 0,
		health = 1,
		max_health = 1,
		attack = 1,
		defence = 1,
		pos_x = 0,
		pos_y = 0
	},
	inventory = [],
	persistence = [],
	quests = [
		#{title = "not found", is_complete = false, completed_steps = [''] }
	],
}

func save_game() -> void:
	update_scene_path()
	update_player_data()
	update_inventory_data()
	update_quest_data()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()

func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	GlobalRegionManager.load_new_region(current_save.scene_path, "", Vector2.ZERO)
	
	await GlobalRegionManager.region_load_started
	
	GlobalPlayerManager.set_player_position(Vector2(current_save.player.pos_x,current_save.player.pos_y))
	GlobalPlayerManager.set_health(current_save.player.health, current_save.player.max_health)
	var p : Player = GlobalPlayerManager.player
	p.level = current_save.player.level
	p.xp = current_save.player.xp
	p.attack = current_save.player.attack
	p.defence = current_save.player.defence
	GlobalPlayerManager.INVENTORY_DATA.parse_save_data(current_save.inventory)
	GlobalQuestManager.current_quests = current_save.quests
	
	await GlobalRegionManager.region_loaded
	
	game_loaded.emit()
	

func update_player_data() -> void:
	var p : Player = GlobalPlayerManager.player
	current_save.player.health = p.health
	current_save.player.max_health = p.max_health
	current_save.player.level = p.level
	current_save.player.xp = p.xp
	current_save.player.attack = p.attack
	current_save.player.defence = p.defence
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	

func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Region:
			p = c.scene_file_path
	current_save.scene_path = p

func update_inventory_data() -> void:
	current_save.inventory = GlobalPlayerManager.INVENTORY_DATA.get_save_data()

func update_quest_data() -> void:
	current_save.quests = GlobalQuestManager.current_quests

func add_persistent_value(value : String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)

func remove_persistent_value(value : String) -> void:
	var p = current_save.persistence as Array
	p.erase(value)

func check_persistent_value(value : String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
