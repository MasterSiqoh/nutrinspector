extends CanvasLayer

@onready var resume_button = $Panel/VBoxContainer/ResumeButton
@onready var save_button = $Panel/VBoxContainer/SaveButton
@onready var main_menu_button = $Panel/VBoxContainer/MainMenuButton
@onready var exit_button = $Panel/VBoxContainer/ExitButton

var save_system

func _ready() -> void:
	if has_node("/root/SaveSystem"):
		save_system = get_node("/root/SaveSystem")
	else:
		print("WARNING: SaveSystem not found in PauseMenu")
	
	resume_button.pressed.connect(_on_resume_pressed)
	save_button.pressed.connect(_on_save_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # ESC key
		toggle_pause()

func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_save_pressed() -> void:
	if not save_system:
		print("Cannot save: SaveSystem not available")
		return
	
	var slot = get_tree().root.get_meta("current_save_slot", -1)
	if slot >= 0:
		if save_system.save_game(slot):
			print("Game saved successfully!")
	else:
		print("No save slot selected")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
