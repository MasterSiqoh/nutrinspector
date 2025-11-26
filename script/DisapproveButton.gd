extends Button

# References to other nodes (will be set in _ready)
var character
var loyang_button
var approve_button
var start_button

func _ready() -> void:
	# Get node references safely
	character = get_node_or_null("../Character")
	loyang_button = get_node_or_null("../LoyangButton")
	approve_button = get_node_or_null("../ApproveButton")
	start_button = get_node_or_null("../StartButton")
	
	pressed.connect(_on_pressed)
	
	# Check if we're restoring a saved game state
	var saved_state = get_tree().root.get_meta("game_state", {})
	if saved_state.size() > 0:
		# Restore visibility from saved state
		visible = saved_state.get("disapprove_visible", false)
	else:
		# Default: invisible at start
		visible = false

func check_day_completion() -> void:
	# Hide nodes
	if character:
		character.visible = false
	if loyang_button:
		loyang_button.visible = false
	if approve_button:
		approve_button.visible = false
	self.visible = false
	
	# Clear current inspection state
	get_tree().root.set_meta("game_in_progress", false)
	get_tree().root.set_meta("food_data", {})
	get_tree().root.set_meta("game_state", {})
	get_tree().root.set_meta("inspection_completed", false)
	
	# Hide nutrition panel
	var main_scene = get_tree().current_scene
	if main_scene and main_scene.has_method("update_nutrition_display"):
		main_scene.update_nutrition_display()
	
	var inspections = get_tree().root.get_meta("inspections_today", 0)
	
	if inspections >= 3:
		# Day is complete, go to day summary
		print("Day complete! Going to summary...")
		get_tree().change_scene_to_file("res://scene/DaySummary.tscn")
	else:
		# Show StartButton for next inspection
		if start_button:
			start_button.visible = true
		
		# Update UI
		if main_scene.has_method("update_ui"):
			main_scene.update_ui()

func _on_pressed() -> void:
	print("=== DISAPPROVE BUTTON CLICKED ===")
	
	# Get food data from root meta
	var food_data = get_tree().root.get_meta("food_data", {})
	
	print("Boolean value:", food_data["is_correct"])
	
	# Check if boolean is false
	if food_data["is_correct"] == false:
		print("Correct! Food was bad. You earned $20!")
		
		# Add money
		var money = get_tree().root.get_meta("money", 100)
		get_tree().root.set_meta("money", money + 20)
	else:
		print("Wrong choice! The food was good. No money earned.")
	
	# Increment inspections regardless of correctness
	var inspections = get_tree().root.get_meta("inspections_today", 0)
	get_tree().root.set_meta("inspections_today", inspections + 1)
	
	# Check if day is complete
	check_day_completion()
