extends Button

# References to other nodes (will be set in _ready)
var character
var loyang_button
var approve_button
var disapprove_button

# Global variables to store the food data
var food_data = {
	"kalori": 0,
	"protein": 0,
	"karbohidrat": 0,
	"lemak": 0,
	"serat": 0,
	"is_correct": false
}

func _ready() -> void:
	# Get node references safely
	character = get_node_or_null("../Character")
	loyang_button = get_node_or_null("../LoyangButton")
	approve_button = get_node_or_null("../ApproveButton")
	disapprove_button = get_node_or_null("../DisapproveButton")
	
	pressed.connect(_on_pressed)
	
	# Check if we're returning from FoodInfo scene (food data exists and game is in progress)
	var existing_food_data = get_tree().root.get_meta("food_data", {})
	var game_in_progress = get_tree().root.get_meta("game_in_progress", false)
	var saved_state = get_tree().root.get_meta("game_state", {})
	
	if game_in_progress and existing_food_data.size() > 0 and saved_state.size() > 0:
		print("=== RESTORING GAME STATE ===")
		# Restore character visibility (buttons handle themselves)
		if character:
			character.visible = saved_state.get("character_visible", true)
		
		# Restore StartButton visibility
		self.visible = saved_state.get("start_visible", false)
		print("Game state restored:", saved_state)

func save_game_state() -> void:
	# Save visibility state of all nodes
	var state = {
		"character_visible": character.visible if character else false,
		"loyang_visible": loyang_button.visible if loyang_button else false,
		"approve_visible": approve_button.visible if approve_button else false,
		"disapprove_visible": disapprove_button.visible if disapprove_button else false,
		"start_visible": self.visible
	}
	get_tree().root.set_meta("game_state", state)
	print("Game state saved:", state)

func _on_pressed() -> void:
	print("=== START BUTTON CLICKED ===")
	
	# Make nodes visible
	if character:
		character.visible = true
	if loyang_button:
		loyang_button.visible = true
	if approve_button:
		approve_button.visible = true
	if disapprove_button:
		disapprove_button.visible = true
	
	# Make StartButton invisible
	self.visible = false
	
	# Generate random boolean first
	food_data["is_correct"] = randf() > 0.5
	
	print("Boolean value:", food_data["is_correct"])
	
	# True ranges for each nutrient
	var true_ranges = {
		"kalori": {"min": 500, "max": 800},
		"protein": {"min": 15, "max": 30},
		"karbohidrat": {"min": 60, "max": 90},
		"lemak": {"min": 15, "max": 25},
		"serat": {"min": 5, "max": 10}
	}
	
	# Generate values based on is_correct
	if food_data["is_correct"]:
		# Generate values within true ranges
		food_data["kalori"] = randi_range(true_ranges["kalori"]["min"], true_ranges["kalori"]["max"])
		food_data["protein"] = randi_range(true_ranges["protein"]["min"], true_ranges["protein"]["max"])
		food_data["karbohidrat"] = randi_range(true_ranges["karbohidrat"]["min"], true_ranges["karbohidrat"]["max"])
		food_data["lemak"] = randi_range(true_ranges["lemak"]["min"], true_ranges["lemak"]["max"])
		food_data["serat"] = randi_range(true_ranges["serat"]["min"], true_ranges["serat"]["max"])
		print("Generated correct values (within true ranges)")
	else:
		# Generate mostly correct values
		food_data["kalori"] = randi_range(true_ranges["kalori"]["min"], true_ranges["kalori"]["max"])
		food_data["protein"] = randi_range(true_ranges["protein"]["min"], true_ranges["protein"]["max"])
		food_data["karbohidrat"] = randi_range(true_ranges["karbohidrat"]["min"], true_ranges["karbohidrat"]["max"])
		food_data["lemak"] = randi_range(true_ranges["lemak"]["min"], true_ranges["lemak"]["max"])
		food_data["serat"] = randi_range(true_ranges["serat"]["min"], true_ranges["serat"]["max"])
		
		# Corrupt one random value (50-100% lower than minimum)
		var keys = ["kalori", "protein", "karbohidrat", "lemak", "serat"]
		var random_key = keys[randi_range(0, keys.size() - 1)]
		var min_value = true_ranges[random_key]["min"]
		
		# Calculate false range: 50-100% lower than minimum
		# If min is 500, false range is 0-250 (50% of 500)
		# If min is 15, false range is 0-7.5 (50% of 15)
		var reduction_percent = randf_range(0.5, 1.0)  # 50% to 100% reduction
		var false_value = int(min_value * (1.0 - reduction_percent))
		food_data[random_key] = false_value
		
		print("Corrupted", random_key, "to", false_value, "(", int(reduction_percent * 100), "% below minimum of", min_value, ")")
	
	print("Food data generated:")
	print("Kalori:", food_data["kalori"], "kkal")
	print("Protein:", food_data["protein"], "g")
	print("Karbohidrat:", food_data["karbohidrat"], "g")
	print("Lemak:", food_data["lemak"], "g")
	print("Serat:", food_data["serat"], "g")
	
	# Store in root node as a meta property (persists between scenes)
	get_tree().root.set_meta("food_data", food_data)
	get_tree().root.set_meta("game_in_progress", true)
	get_tree().root.set_meta("inspection_completed", false)
	
	# Update the nutrition display in Main scene
	var main_node = get_tree().current_scene
	if main_node and main_node.has_method("update_nutrition_display"):
		main_node.update_nutrition_display()
	
	# Save the visibility state
	save_game_state()
