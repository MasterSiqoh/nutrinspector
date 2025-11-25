extends Control

@onready var day_label = $VBoxContainer/DayLabel
@onready var money_label = $VBoxContainer/MoneyLabel
@onready var expense_label = $VBoxContainer/ExpenseLabel
@onready var result_label = $VBoxContainer/ResultLabel
@onready var continue_button = $VBoxContainer/ContinueButton
@onready var game_over_panel = $GameOverPanel
@onready var main_menu_button = $GameOverPanel/VBoxContainer/MainMenuButton

const DAILY_EXPENSE = 20
var save_system

func _ready() -> void:
	if has_node("/root/SaveSystem"):
		save_system = get_node("/root/SaveSystem")
	
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	var day = get_tree().root.get_meta("day", 1)
	var money = get_tree().root.get_meta("money", 100)
	
	day_label.text = "Day: %d" % day
	money_label.text = "Money: $%d" % money
	expense_label.text = "Daily Expense: -$%d" % DAILY_EXPENSE
	
	var remaining = money - DAILY_EXPENSE
	result_label.text = "Remaining: $%d" % remaining
	
	if remaining < 0:
		# Game Over
		game_over_panel.visible = true
		continue_button.visible = false
	else:
		# Continue to upgrade screen
		get_tree().root.set_meta("money", remaining)

func _on_continue_pressed() -> void:
	# Go to upgrade screen
	get_tree().change_scene_to_file("res://scene/UpgradeShop.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
