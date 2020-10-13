extends StaticBody2D


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

func interact(player):
	player.hp = player.maxHp
	player.ammo = player.maxAmmo
	
	global_vars.save_data(position)

#	var data = {
#		"position": position
#	}
#
#	var file = File.new()
#	var error = file.open(global_vars.save_path, File.WRITE)
#	if error == OK:
#		file.store_var(data)
#		file.close()
