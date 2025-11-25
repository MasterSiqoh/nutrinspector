extends Button

# References to other nodes (will be set in _ready)
var character
var loyang_button
var disapprove_button
var start_button

func _ready() -> void:
	# Get node references safely
	character = get_node_or_null("../Character")
	loyang_button = get_node_or_null("../LoyangButton")
	disapprove_button = get_node_or_null("../DisapproveButton")
	start_button = get_node_or_null("../StartButton")
	
	pressed.connect(_on_pressed)
	
	# Check if we're restoring a saved game state
	var saved_state = get_tree().root.get_meta("game_state", {})
	if saved_state.size() > 0:
		# Restore visibility from saved state
		visible = saved_state.get("approve_visible", false)
	else:
		# Default: invisible at start
		visible = false

func check_day_completion() -> void:
	# Hide nodes
	if character:
		character.visible = false
	if loyang_button:
		loyang_button.visible = false
	if disapprove_button:
		disapprove_button.visible = false
	self.visible = false
	
	# Clear current inspection state
	get_tree().root.set_meta("game_in_progress", false)
	get_tree().root.set_meta("food_data", {})
	get_tree().root.set_meta("game_state", {})
	
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
		var main_scene = get_tree().current_scene
		if main_scene.has_method("update_ui"):
			main_scene.update_ui()

func _on_pressed() -> void:
	print("=== APPROVE BUTTON CLICKED ===")
	
	# Get food data from root meta
	var food_data = get_tree().root.get_meta("food_data", {})
	
	print("Boolean value:", food_data["is_correct"])
	
	# Check if boolean is true
	if food_data["is_correct"] == true:
		print("Correct! Food was good. You earned $20!")
		
		# Add money
		var money = get_tree().root.get_meta("money", 100)
		get_tree().root.set_meta("money", money + 20)
		
		# Increment inspections
		var inspections = get_tree().root.get_meta("inspections_today", 0)
		get_tree().root.set_meta("inspections_today", inspections + 1)
		
		# Check if day is complete
		check_day_completion()
	else:
		print("Wrong choice! The food was incorrect. No money earned.")
