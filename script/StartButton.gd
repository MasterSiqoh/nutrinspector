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
	
	# Generate random values for 5 variables (range 1-10)
	food_data["kalori"] = randi_range(1, 10)
	food_data["protein"] = randi_range(1, 10)
	food_data["karbohidrat"] = randi_range(1, 10)
	food_data["lemak"] = randi_range(1, 10)
	food_data["serat"] = randi_range(1, 10)
	
	# Generate random boolean
	food_data["is_correct"] = randf() > 0.5
	
	print("Boolean value:", food_data["is_correct"])
	
	# If boolean is false, modify one random variable
	if not food_data["is_correct"]:
		var keys = ["kalori", "protein", "karbohidrat", "lemak", "serat"]
		var random_key = keys[randi_range(0, keys.size() - 1)]
		
		# Randomly choose to set to 0 or multiply by 10
		if randf() > 0.5:
			food_data[random_key] = 0
			print("Set", random_key, "to 0")
		else:
			food_data[random_key] *= 10
			print("Multiplied", random_key, "by 10")
	
	print("Food data generated:")
	print("Kalori:", food_data["kalori"])
	print("Protein:", food_data["protein"])
	print("Karbohidrat:", food_data["karbohidrat"])
	print("Lemak:", food_data["lemak"])
	print("Serat:", food_data["serat"])
	
	# Store in root node as a meta property (persists between scenes)
	get_tree().root.set_meta("food_data", food_data)
	get_tree().root.set_meta("game_in_progress", true)
	
	# Save the visibility state
	save_game_state()
