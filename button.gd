extends Button

@onready var character := $"../Character"

func _ready() -> void:
	# Hubungkan signal pressed ke fungsi _on_pressed
	pressed.connect(_on_pressed)
	
	# kalau mau, sembunyikan dulu di awal
	if character:
		character.visible = false
		print("Character ditemukan:", character)
	else:
		print("Character TIDAK ketemu, cek lagi pathnya.")

# Fungsi ini dipanggil saat button ditekan
func _on_pressed() -> void:
	print("=== BUTTON CLICKED ===")
	if character:
		print("Character sebelum diubah, visible:", character.visible)
		character.visible = true
		print("Character setelah diubah, visible:", character.visible)
		print("Character position:", character.position)
	else:
		print("Character adalah null!")
