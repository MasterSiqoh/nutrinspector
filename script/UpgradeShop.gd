extends Control

@onready var money_label = $VBoxContainer/MoneyLabel
@onready var buy_button = $VBoxContainer/SpeedUpgrade/BuyButton
@onready var start_day_button = $VBoxContainer/StartDayButton

const SPEED_UPGRADE_COST = 50
var save_system

func _ready() -> void:
	if has_node("/root/SaveSystem"):
		save_system = get_node("/root/SaveSystem")
	
	buy_button.pressed.connect(_on_buy_pressed)
	start_day_button.pressed.connect(_on_start_day_pressed)
	
	update_ui()

func update_ui() -> void:
	var money = get_tree().root.get_meta("money", 100)
	var upgrade_speed = get_tree().root.get_meta("upgrade_speed", false)
	
	money_label.text = "Money: $%d" % money
	
	if upgrade_speed:
		buy_button.text = "Purchased"
		buy_button.disabled = true
	elif money < SPEED_UPGRADE_COST:
		buy_button.text = "Not enough money"
		buy_button.disabled = true
	else:
		buy_button.text = "Buy ($%d)" % SPEED_UPGRADE_COST
		buy_button.disabled = false

func _on_buy_pressed() -> void:
	var money = get_tree().root.get_meta("money", 100)
	if money >= SPEED_UPGRADE_COST:
		get_tree().root.set_meta("money", money - SPEED_UPGRADE_COST)
		get_tree().root.set_meta("upgrade_speed", true)
		update_ui()
		print("Upgrade purchased!")

func _on_start_day_pressed() -> void:
	# Increment day and reset inspections
	var day = get_tree().root.get_meta("day", 1)
	get_tree().root.set_meta("day", day + 1)
	get_tree().root.set_meta("inspections_today", 0)
	
	# Save game before starting new day
	if save_system:
		var slot = get_tree().root.get_meta("current_save_slot", -1)
		if slot >= 0:
			save_system.save_game(slot)
	
	# Go back to main game
	get_tree().change_scene_to_file("res://scene/Main.tscn")
