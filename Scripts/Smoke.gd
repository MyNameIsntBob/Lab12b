extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var smoke_diration = 10
var timer = 0
var fade_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = smoke_diration
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	modulate = Color(1,1,1,timer/smoke_diration)
	if timer <= 0:
		queue_free()


func _on_Smoke_body_entered(body):
	body.hidden = true


func _on_Smoke_body_exited(body):
	body.hidden = false
