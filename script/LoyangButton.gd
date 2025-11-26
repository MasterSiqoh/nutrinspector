extends Button

var progress_bar
var is_loading = false
var load_time = 0.0
var base_load_time = 3.0
var total_load_time = 3.0

func _ready() -> void:
	pressed.connect(_on_pressed)
	
	# Check if we're restoring a saved game state
	var saved_state = get_tree().root.get_meta("game_state", {})
	if saved_state.size() > 0:
		# Restore visibility from saved state
		visible = saved_state.get("loyang_visible", false)
	else:
		# Default: invisible at start
		visible = false
	
	# Create and setup progress bar
	progress_bar = ProgressBar.new()
	add_child(progress_bar)
	
	progress_bar.visible = false
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 0
	
	# Position progress bar above the button
	progress_bar.position = Vector2(0, -30)
	progress_bar.size = Vector2(size.x, 20)

func _process(delta: float) -> void:
	if is_loading:
		load_time += delta
		var progress = (load_time / total_load_time) * 100
		progress_bar.value = progress
		
		# When loading is complete
		if load_time >= total_load_time:
			is_loading = false
			progress_bar.visible = false
			load_time = 0.0
			
			# Mark inspection as completed so clipboard can show
			get_tree().root.set_meta("inspection_completed", true)
			
			# Just show the clipboard nutrition panel, don't change scene
			print("Loading complete! Nutrition info is now visible on clipboard.")
			var main_scene = get_tree().current_scene
			if main_scene and main_scene.has_method("update_nutrition_display"):
				main_scene.update_nutrition_display()

func save_game_state() -> void:
	# Get all node references
	var character = get_node_or_null("../Character")
	var loyang_button = get_node_or_null("../LoyangButton")
	var approve_button = get_node_or_null("../ApproveButton")
	var disapprove_button = get_node_or_null("../DisapproveButton")
	var start_button = get_node_or_null("../StartButton")
	
	# Save visibility state of all nodes
	var state = {
		"character_visible": character.visible if character else false,
		"loyang_visible": loyang_button.visible if loyang_button else false,
		"approve_visible": approve_button.visible if approve_button else false,
		"disapprove_visible": disapprove_button.visible if disapprove_button else false,
		"start_visible": start_button.visible if start_button else false
	}
	get_tree().root.set_meta("game_state", state)
	print("Game state saved from LoyangButton:", state)

func _on_pressed() -> void:
	if not is_loading:
		print("=== LOYANG BUTTON CLICKED ===")
		
		# Check if upgrade is purchased
		var upgrade_speed = get_tree().root.get_meta("upgrade_speed", false)
		if upgrade_speed:
			total_load_time = base_load_time / 2.0  # 2x faster
			print("Using speed upgrade! Loading in", total_load_time, "seconds")
		else:
			total_load_time = base_load_time
			print("Loading in", total_load_time, "seconds")
		
		print("Loading started...")
		is_loading = true
		progress_bar.visible = true
		progress_bar.value = 0
		load_time = 0.0
