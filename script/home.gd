extends Area2D

@onready var character = $"../Character"  # ambil node Character di atasnya

func _ready():
	# Pastikan karakter awalnya tidak terlihat
	character.visible = false

func _on_home_input_event(viewport, event, shape_idx):
	print("Input event MASUK:", event)
