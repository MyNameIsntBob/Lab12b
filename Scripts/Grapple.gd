extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100

var movement

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = Vector2(0, 0)
	pass # Replace with function body.

func retract():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
			
	var collision = self.move_and_collide(movement)
		
	if (collision):
		if (collision.collider.name != "Pipes"):
			retract()
		else:
			find_parent("Master").find_node("Player").go_to_pipe(self.get_global_transform().get_origin())
	else:
		movement.y = -speed * delta
	
