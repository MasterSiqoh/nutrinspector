extends Node

const SAVE_DIR = "user://saves/"
const MAX_SAVES = 3

# Save data structure
class SaveData:
	var slot: int = 0
	var money: int = 100
	var day: int = 1
	var inspections_today: int = 0
	var upgrade_speed: bool = false
	var save_date: String = ""
	
	func to_dict() -> Dictionary:
		return {
			"slot": slot,
			"money": money,
			"day": day,
			"inspections_today": inspections_today,
			"upgrade_speed": upgrade_speed,
			"save_date": save_date
		}
	
	func from_dict(data: Dictionary) -> void:
		slot = data.get("slot", 0)
		money = data.get("money", 100)
		day = data.get("day", 1)
		inspections_today = data.get("inspections_today", 0)
		upgrade_speed = data.get("upgrade_speed", false)
		save_date = data.get("save_date", "")

func _ready() -> void:
	# Create save directory if it doesn't exist
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

func save_game(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SAVES:
		print("Invalid save slot:", slot)
		return false
	
	var save_data = SaveData.new()
	save_data.slot = slot
	save_data.money = get_tree().root.get_meta("money", 100)
	save_data.day = get_tree().root.get_meta("day", 1)
	save_data.inspections_today = get_tree().root.get_meta("inspections_today", 0)
	save_data.upgrade_speed = get_tree().root.get_meta("upgrade_speed", false)
	save_data.save_date = Time.get_datetime_string_from_system()
	
	var file = FileAccess.open(SAVE_DIR + "save_" + str(slot) + ".json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data.to_dict()))
		file.close()
		print("Game saved to slot", slot)
		return true
	else:
		print("Failed to save game to slot", slot)
		return false

func load_game(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SAVES:
		print("Invalid save slot:", slot)
		return false
	
	var file_path = SAVE_DIR + "save_" + str(slot) + ".json"
	if not FileAccess.file_exists(file_path):
		print("Save file doesn't exist:", file_path)
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var save_data = SaveData.new()
			save_data.from_dict(json.data)
			
			# Load data into game
			get_tree().root.set_meta("current_save_slot", slot)
			get_tree().root.set_meta("money", save_data.money)
			get_tree().root.set_meta("day", save_data.day)
			get_tree().root.set_meta("inspections_today", save_data.inspections_today)
			get_tree().root.set_meta("upgrade_speed", save_data.upgrade_speed)
			
			print("Game loaded from slot", slot)
			return true
		else:
			print("Failed to parse save file")
			return false
	else:
		print("Failed to open save file")
		return false

func get_save_info(slot: int) -> Dictionary:
	if slot < 0 or slot >= MAX_SAVES:
		return {}
	
	var file_path = SAVE_DIR + "save_" + str(slot) + ".json"
	if not FileAccess.file_exists(file_path):
		return {"exists": false, "slot": slot}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var data = json.data
			data["exists"] = true
			return data
		else:
			return {"exists": false, "slot": slot}
	else:
		return {"exists": false, "slot": slot}

func delete_save(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SAVES:
		return false
	
	var file_path = SAVE_DIR + "save_" + str(slot) + ".json"
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		print("Save deleted from slot", slot)
		return true
	return false

func new_game() -> void:
	# Initialize new game data
	get_tree().root.set_meta("money", 100)
	get_tree().root.set_meta("day", 1)
	get_tree().root.set_meta("inspections_today", 0)
	get_tree().root.set_meta("upgrade_speed", false)
	get_tree().root.set_meta("game_in_progress", false)
	get_tree().root.set_meta("current_save_slot", -1)
	print("New game initialized")
