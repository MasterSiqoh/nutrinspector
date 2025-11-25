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

func _on_pressed() -> void:
	print("=== DISAPPROVE BUTTON CLICKED ===")
	
	# Get food data from root meta
	var food_data = get_tree().root.get_meta("food_data", {})
	
	print("Boolean value:", food_data["is_correct"])
	
	# Check if boolean is false
	if food_data["is_correct"] == false:
		print("Correct! Resetting game...")
		
		# Hide nodes
		if character:
			character.visible = false
		if loyang_button:
			loyang_button.visible = false
		if approve_button:
			approve_button.visible = false
		self.visible = false
		
		# Show StartButton again
		if start_button:
			start_button.visible = true
		
		# Clear game state
		get_tree().root.set_meta("game_in_progress", false)
		get_tree().root.set_meta("food_data", {})
		get_tree().root.set_meta("game_state", {})
	else:
		print("Wrong choice! The food was correct.")
