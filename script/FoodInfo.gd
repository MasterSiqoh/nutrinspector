extends Control

var kalori_label
var protein_label
var karbohidrat_label
var lemak_label
var serat_label
var back_button

func _ready() -> void:
	# Get node references safely
	kalori_label = get_node_or_null("VBoxContainer/KaloriLabel")
	protein_label = get_node_or_null("VBoxContainer/ProteinLabel")
	karbohidrat_label = get_node_or_null("VBoxContainer/KarbohidratLabel")
	lemak_label = get_node_or_null("VBoxContainer/LemakLabel")
	serat_label = get_node_or_null("VBoxContainer/SeratLabel")
	back_button = get_node_or_null("VBoxContainer/BackButton")
	
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)
	
	# Get food data from root meta
	var food_data = get_tree().root.get_meta("food_data", {})
	
	if food_data and food_data.size() > 0:
		
		# Display the food information (excluding boolean)
		kalori_label.text = "Kalori: " + str(food_data["kalori"])
		protein_label.text = "Protein: " + str(food_data["protein"])
		karbohidrat_label.text = "Karbohidrat: " + str(food_data["karbohidrat"])
		lemak_label.text = "Lemak: " + str(food_data["lemak"])
		serat_label.text = "Serat: " + str(food_data["serat"])
		
		print("Displaying food info:")
		print(food_data)

func _on_back_button_pressed() -> void:
	# Go back to main scene
	print("Going back to Main scene...")
	get_tree().change_scene_to_file("res://scene/Main.tscn")
