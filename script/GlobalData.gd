extends Node

# Singleton pattern - can be accessed from anywhere
static var instance: Node = null

# Global storage for food data that persists between scenes
var food_data = {
	"kalori": 0,
	"protein": 0,
	"karbohidrat": 0,
	"lemak": 0,
	"serat": 0,
	"is_correct": false
}

func _init():
	if instance == null:
		instance = self

static func get_instance():
	if instance == null:
		instance = Node.new()
		instance.set_script(load("res://script/GlobalData.gd"))
	return instance
