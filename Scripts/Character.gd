extends KinematicBody2D


var gravity : = 750.0
var movement : = Vector2(0, 0)
var state
var canFall : = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	self.move_and_slide(movement, Vector2(0, -1))
