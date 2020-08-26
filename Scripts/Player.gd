extends KinematicBody2D

enum {
	NORMAL,
	PIPECRAWL,
	GRAPPLING
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# powerups
# grapple
# stun grandates 
# smoke clowd 
# key card
# rock (maybe) to distract the npc's
# invisibility cloak (maybe)

const GRAPPLE = preload("res://Prefabs/Grapple.tscn")

var moveSpeed = 150
var gravity = 20
var jumpForce = 300

var jumpPadding = 0.1
var jumpPaddingCounter = 0.0

var jumpTime = 0.25
var jumpTimeCounter = 0.0

var cancelJump = 0.1
var cancelJumpCounter = 0.0

var crawlLeft = false
var crawlRight = false
var movement
var jumpAgain = false

var state = NORMAL

var grapple

# Called when the node enters the scene tree for the first time.
func _ready():
	movement = Vector2(0, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state: 
		NORMAL:
			normal(delta)
		PIPECRAWL:
			pipeCrawl(delta)
		GRAPPLING:
			grappling()
	
	self.move_and_slide(movement, Vector2(0, -1))
	

func pipeCrawl(delta):
	if (Input.is_action_just_pressed("ui_down")):
		state=NORMAL
	
	movement = Vector2(0, 0)
	
	if (Input.is_action_pressed("ui_left") and crawlLeft):
		movement.x -= moveSpeed
	if (Input.is_action_pressed("ui_right") and crawlRight):
		movement.x += moveSpeed
	
func startGrappling():
	state=GRAPPLING
	grapple()

func grappling():
	if (grapple == null):
		state = NORMAL
	
	movement.x = 0
	
	if (!Input.is_action_pressed("ui_up")):
		state = NORMAL
		grapple.retract()
	pass	
	
func grapple():
	grapple = GRAPPLE.instance()
	grapple.set_position($Position2D.get_global_position())
	find_parent("Master").add_child(grapple)

func hurt(damage):
	print("Ouch")

func go_to_pipe(position):
	if state == GRAPPLING:
		if (grapple):
			grapple.queue_free()
		
		self.set_position(position)
	
		state = PIPECRAWL
	
func normal(delta):
	if (Input.is_action_just_pressed("ui_up") && grapple == null):
		startGrappling()
	
	if (!self.is_on_floor()):
		jumpPaddingCounter -= delta
		movement.y += gravity
	else:
		movement.y = 0
		jumpPaddingCounter = jumpPadding
	
	movement.x = 0
	
	if Input.is_action_pressed("ui_right"):
		movement.x += moveSpeed
		
	if Input.is_action_pressed("ui_left"):
		movement.x -= moveSpeed
	
	if cancelJumpCounter < 0:
		jumpAgain = false
	else:
		cancelJumpCounter -= delta
	
	if (Input.is_action_just_pressed("ui_jump")):
		cancelJumpCounter = cancelJump
		jumpAgain = true
	
	if (self.is_on_floor() or jumpPaddingCounter > 0) and (Input.is_action_just_pressed("ui_jump") or jumpAgain):
		jumpAgain = false
		movement.y = -jumpForce
		jumpPaddingCounter = 0
		jumpTimeCounter = jumpTime
	
	if (Input.is_action_pressed("ui_jump")):
		if jumpTimeCounter > 0:
			movement.y = -jumpForce
			jumpTimeCounter -= delta
	else:
		jumpTimeCounter = 0
		
	if (self.is_on_ceiling()):
		jumpTimeCounter = 0
		if (movement.y < 0):
			movement.y = 0
			
	


func _on_leftArea_body_entered(body):
	crawlLeft = true
	pass # Replace with function body.


func _on_leftArea_body_exited(body):
	crawlLeft = false
	pass # Replace with function body.


func _on_rightArea_body_entered(body):
	crawlRight = true
	pass # Replace with function body.


func _on_rightArea_body_exited(body):
	crawlRight = false
	pass # Replace with function body.
