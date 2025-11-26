extends Node2D

@onready var day_label = $UI/DayLabel
@onready var money_label = $UI/MoneyLabel
@onready var inspections_label = $UI/InspectionsLabel
@onready var pause_menu = $PauseMenu
@onready var nutrition_panel = $UI/NutritionPanel
@onready var kalori_label = $UI/NutritionPanel/VBoxContainer/KaloriLabel
@onready var protein_label = $UI/NutritionPanel/VBoxContainer/ProteinLabel
@onready var karbohidrat_label = $UI/NutritionPanel/VBoxContainer/KarbohidratLabel
@onready var lemak_label = $UI/NutritionPanel/VBoxContainer/LemakLabel
@onready var serat_label = $UI/NutritionPanel/VBoxContainer/SeratLabel

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
	update_nutrition_display()

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

func update_nutrition_display() -> void:
	# Check if loyang inspection was completed
	var inspection_completed = get_tree().root.get_meta("inspection_completed", false)
	
	if get_tree().root.has_meta("food_data") and inspection_completed:
		var food_data = get_tree().root.get_meta("food_data")
		if nutrition_panel:
			nutrition_panel.visible = true
		if kalori_label:
			kalori_label.text = "Kalori: %d kkal" % food_data["kalori"]
		if protein_label:
			protein_label.text = "Protein: %d g" % food_data["protein"]
		if karbohidrat_label:
			karbohidrat_label.text = "Karbohidrat: %d g" % food_data["karbohidrat"]
		if lemak_label:
			lemak_label.text = "Lemak: %d g" % food_data["lemak"]
		if serat_label:
			serat_label.text = "Serat: %d g" % food_data["serat"]
	else:
		if nutrition_panel:
			nutrition_panel.visible = false
