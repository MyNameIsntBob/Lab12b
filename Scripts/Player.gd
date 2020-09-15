extends "res://Scripts/Character.gd"

enum {
	NORMAL,
	PIPECRAWL,
	GRAPPLING, 
	DEAD,
	HIDDEN
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
var jumpForce = 300

var jumpPadding = 0.1
var jumpPaddingCounter = 0.0

var jumpTime = 0.25
var jumpTimeCounter = 0.0

var cancelJump = 0.1
var cancelJumpCounter = 0.0

var crawlLeft = false
var crawlRight = false
var jumpAgain = false

var maxHp = 3
var hp

var interactable = []

var grapple

var default_layer

# Called when the node enters the scene tree for the first time.
func _ready():
	state = NORMAL
	default_layer = self.get_collision_layer()
	hp = maxHp
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
		DEAD:
			dead()
		HIDDEN:
			hidden()
	
	if hp <= 0:
		die()

func interact():
	var closest
	var minDist = -1
	for body in interactable:
		var dist = self.get_global_position().distance_to(body.get_global_position())
		if minDist < 0 or minDist < dist:
			closest = body
	if closest != null:
		set_hide(closest.position)

	else:
		print("Nothing to interact with")

func set_hide(location):
	self.hide()
	set_collision_layer(0)
	self.movement = Vector2(0, 0)
	self.position = location
	state = HIDDEN
	

func hidden():
	canFall = false
	if Input.is_action_just_pressed("ui_interact") or Input.is_action_just_pressed("ui_jump"):
		state = NORMAL
		self.show()
		self.set_collision_layer(default_layer)

func die():
	movement = Vector2(0, 0)
	state = DEAD

func dead():
	canFall = true
	pass

func pipeCrawl(delta):
	canFall = false
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
	canFall = true
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
	hp -= damage

func go_to_pipe(position):
	if state == GRAPPLING:
		if (grapple):
			grapple.queue_free()
		
		self.set_position(position)
	
		state = PIPECRAWL
	
func normal(delta):
	canFall = true
	if (Input.is_action_just_pressed("ui_up") && grapple == null):
		startGrappling()
		
	if Input.is_action_just_pressed("ui_interact") and is_on_floor():
		interact()
		
	if (!self.is_on_floor()):
		movement.y += gravity * delta
		jumpPaddingCounter -= delta
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


func _on_Interactable_body_entered(body):
	interactable.append(body)
	pass # Replace with function body.


func _on_Interactable_body_exited(body):
	for i in range(len(interactable)):
		if interactable[i] == body:
			interactable.remove(i)
	
	pass # Replace with function body.
