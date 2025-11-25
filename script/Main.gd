extends Node2D

@onready var day_label = $UI/DayLabel
@onready var money_label = $UI/MoneyLabel
@onready var inspections_label = $UI/InspectionsLabel
@onready var pause_menu = $PauseMenu

func _ready() -> void:
	# Initialize game values if not set
	if not get_tree().root.has_meta("money"):
		get_tree().root.set_meta("money", 100)
	if not get_tree().root.has_meta("day"):
		get_tree().root.set_meta("day", 1)
	if not get_tree().root.has_meta("inspections_today"):
		get_tree().root.set_meta("inspections_today", 0)
	if not get_tree().root.has_meta("upgrade_speed"):
		get_tree().root.set_meta("upgrade_speed", false)
	
	update_ui()

func update_ui() -> void:
	var day = get_tree().root.get_meta("day", 1)
	var money = get_tree().root.get_meta("money", 100)
	var inspections = get_tree().root.get_meta("inspections_today", 0)
	
	if day_label:
		day_label.text = "Day: %d" % day
	if money_label:
		money_label.text = "Money: $%d" % money
	if inspections_label:
		inspections_label.text = "Inspections: %d/3" % inspections
