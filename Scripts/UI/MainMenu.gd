extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var global_vars = get_node('/root/Global')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_New_pressed():
	global_vars.new_game()


func _on_Continue_pressed():
	global_vars.load_game()


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
