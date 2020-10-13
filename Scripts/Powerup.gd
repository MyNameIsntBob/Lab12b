extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var id
#export(str) var image 

onready var global_vars = get_node('/root/Global')

# Called when the node enters the scene tree for the first time.
func _ready():
	if global_vars.powers[id]:
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func interact(player):
	player.power_up(id)
	queue_free()

