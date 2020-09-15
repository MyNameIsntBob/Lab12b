extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moveSpeed = 10
var movement
var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready():
#	movement = Vector2(0, 0)
#	movement = Vector2(speed, 0).rotated(rotation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	movement.x = moveSpeed
	movement = Vector2(moveSpeed, 0).rotated(rotation)
#	movement.rotated(rotation)
	
	var collision = move_and_collide(movement)
	
	if (collision):
		queue_free()
		if collision.collider.name == 'Player':
			collision.collider.hurt(damage)
