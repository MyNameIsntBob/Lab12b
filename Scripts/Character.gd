extends KinematicBody2D


var gravity : = 750.0
var movement : = Vector2(0, 0)
var state
var canFall : = true
var jumpForce : = 200
var moveSpeed : = 150
var friction 
var airResistance

var jumping : = false
var jumpTime : = 0.25
var jumpTimeCounter : = 0.0 

# coyote jump
var jumpPadding : = 0.1
var jumpPaddingCounter : = 0.0

var cancelJump : = 0.1
var cancelJumpCounter : = 0.0
var jumpAgain = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func jump():
	movement.y = -jumpForce
	
func moveRight():
	movement.x += moveSpeed
	
func moveLeft():
	movement.x -= moveSpeed

func startJumping():
	if (is_on_floor()):
		jump()
		jumpPaddingCounter = 0
		jumpTimeCounter = jumpTime
		jumping = true
		jumpAgain = false
	else:
		cancelJumpCounter = cancelJump
		jumpAgain = true
	
func stopJumping():
	jumping = false
	jumpTimeCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (jumping):
		jump()

#	Timers
	if jumpTimeCounter > 0:
		jumpTimeCounter -= delta
	else:
		stopJumping()
		
	if jumpPaddingCounter > 0:
		jumpPaddingCounter -= delta
	
	if cancelJumpCounter < 0:
		jumpAgain = false
	else:
		cancelJumpCounter -= delta
		
	if (self.is_on_floor() and jumpAgain):
		startJumping()
	
	if (self.is_on_ceiling() and movement.y < 0 and canFall):
		movement.y = 0
		stopJumping()
		
	
	if (!self.is_on_floor() and canFall):
		jumpPaddingCounter -= delta
		movement.y += gravity * delta
	elif movement.y > 0:
		jumpPaddingCounter = jumpPadding
		movement.y = 10 # Look into this. WTF is the enemy not on the floor unless I keep a constand big downwards motion on him
	
	self.move_and_slide(movement, Vector2(0, -1))
