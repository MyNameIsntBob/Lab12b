extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_path = "user://save.dat"
var gravity

var startPos

var mainScene = 'res://Scenes/Main.tscn'
var mainMenu = 'res://Scenes/MainMenu.tscn'

enum {
	GRAPPLE,
	DOUBLE,
	DASH,
	SMOKEBOMB
}

var powers = {
	GRAPPLE: false,
	DOUBLE: false,
	DASH: false,
	SMOKEBOMB: false
}

#onready var root_node = get_tree().get_root().get_node("Master")

func new_game():
	var dir = Directory.new()
	dir.remove(save_path)
	load_game()

func save_data(position):
	
	var data = {
		"position": position,
		"powers": powers,
		"scene": get_tree().get_current_scene().filename
	}

	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
	
func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var data = file.get_var()
			file.close()
		
#			get_tree().get_current_scene().get_name()
#			print(data["scene"])
			get_tree().change_scene(data["scene"])
			startPos = data['position']
#			get_tree().get_root().find_node("Player").position = data['position']
#			get_tree().get_root().get_node('Master').find_node('Player').position = data["position"]
#			find_node('Player').position = data['position']
			powers = data["powers"]
	else:
		print("going to main scene")
		get_tree().change_scene(mainScene)

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
