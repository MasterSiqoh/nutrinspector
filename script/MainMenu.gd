extends Control

@onready var new_game_button = $VBoxContainer/NewGameButton
@onready var load_game_button = $VBoxContainer/LoadGameButton
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var exit_button = $VBoxContainer/ExitButton
@onready var save_select_panel = $SaveSelectPanel
@onready var slot_buttons = [
	$SaveSelectPanel/VBoxContainer/Slot0,
	$SaveSelectPanel/VBoxContainer/Slot1,
	$SaveSelectPanel/VBoxContainer/Slot2
]
@onready var back_button = $SaveSelectPanel/VBoxContainer/BackButton

var save_system
var is_new_game_mode = false

func _ready() -> void:
	# Get SaveSystem
	if has_node("/root/SaveSystem"):
		save_system = get_node("/root/SaveSystem")
	else:
		print("ERROR: SaveSystem not found! Please add SaveSystem.gd as Autoload in Project Settings.")
		print("Go to: Project → Project Settings → Autoload")
		print("Add: res://script/SaveSystem.gd with name 'SaveSystem'")
		return
	
	# Connect buttons
	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(_on_load_game_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	for i in range(3):
		slot_buttons[i].pressed.connect(_on_slot_pressed.bind(i))
	
	# Check if there's any save file
	update_continue_button()
	update_save_slots()

func update_continue_button() -> void:
	if not save_system:
		if continue_button:
			continue_button.disabled = true
		return
	
	var has_save = false
	for i in range(3):
		var save_info = save_system.get_save_info(i)
		if save_info.get("exists", false):
			has_save = true
			break
	
	continue_button.disabled = not has_save

func update_save_slots() -> void:
	if not save_system:
		return
	
	for i in range(3):
		var save_info = save_system.get_save_info(i)
		if save_info.get("exists", false):
			var text = "Slot %d: Day %d - $%d" % [i + 1, save_info.get("day", 1), save_info.get("money", 0)]
			slot_buttons[i].text = text
		else:
			slot_buttons[i].text = "Slot %d: Empty" % (i + 1)

func _on_new_game_pressed() -> void:
	is_new_game_mode = true
	$VBoxContainer.visible = false
	save_select_panel.visible = true
	update_save_slots()

func _on_load_game_pressed() -> void:
	is_new_game_mode = false
	$VBoxContainer.visible = false
	save_select_panel.visible = true
	update_save_slots()

func _on_continue_pressed() -> void:
	# Load the most recent save
	var most_recent_slot = -1
	var most_recent_date = ""
	
	for i in range(3):
		var save_info = save_system.get_save_info(i)
		if save_info.get("exists", false):
			var save_date = save_info.get("save_date", "")
			if most_recent_slot == -1 or save_date > most_recent_date:
				most_recent_slot = i
				most_recent_date = save_date
	
	if most_recent_slot >= 0:
		if save_system.load_game(most_recent_slot):
			get_tree().change_scene_to_file("res://scene/Main.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	save_select_panel.visible = false
	$VBoxContainer.visible = true

func _on_slot_pressed(slot: int) -> void:
	if is_new_game_mode:
		# Start new game in this slot
		save_system.new_game()
		get_tree().root.set_meta("current_save_slot", slot)
		save_system.save_game(slot)
		get_tree().change_scene_to_file("res://scene/Main.tscn")
	else:
		# Load game from this slot
		var save_info = save_system.get_save_info(slot)
		if save_info.get("exists", false):
			if save_system.load_game(slot):
				get_tree().change_scene_to_file("res://scene/Main.tscn")
		else:
			print("No save in this slot")
