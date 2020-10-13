extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node('/root/Global')

# Called when the node enters the scene tree for the first time.
func _ready():
	if global_vars.startPos:
		find_node('Player').position = global_vars.startPos

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
#func load_game():
#	var file = File.new()
#	if file.file_exists(global_vars.save_path):
#		var error = file.open(global_vars.save_path, File.READ)
#		if error == OK:
#			var player_date = file.get_var()
#			file.close()
#
#			find_node('Player').position = player_date['position']
