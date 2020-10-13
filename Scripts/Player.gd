extends "res://Scripts/Character.gd"

enum {
	NORMAL,
	PIPECRAWL,
	GRAPPLING, 
	DEAD,
	CRATE
}
# powerups
# grapple
# stun grandates 
# smoke clowd 
# key card
# rock (maybe) to distract the npc's
# invisibility cloak (maybe)

const GRAPPLE = preload("res://Prefabs/Grapple.tscn")
const SMOKE = preload("res://Prefabs/Smoke.tscn")

var crawlLeft = false
var crawlRight = false

var hidden = false

var maxHp = 3
var hp

var interactable = []

var grapple
var maxAmmo = 3
var ammo

var default_layer
const hidden_layer = 4

onready var global_vars = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	state = NORMAL
	default_layer = self.get_collision_layer()
	hp = maxHp
	ammo = maxAmmo
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
		CRATE:
			crate()
	
	if hp <= 0:
		die()
		
	if hidden:
		set_collision_layer(hidden_layer)
	else:
		set_collision_layer(default_layer)

func interact():
	var closest
	var minDist = -1
	for body in interactable:
		if body:
			var dist = self.get_global_position().distance_to(body.get_global_position())
			if minDist < 0 or minDist < dist:
				closest = body
	if closest != null:
		closest.interact(self)

	else:
		print("Nothing to interact with")
		
func smoke_screen():
	if !global_vars.powers[global_vars.SMOKEBOMB]:
		return
	
	if ammo > 0:
		var smoke = SMOKE.instance()
		get_parent().add_child(smoke)
		smoke.position = position
		ammo -= 1

func set_hide(location):
	self.hide()
	self.position = location
	state = CRATE

func crate():
	movement = Vector2(0, 0)
	canFall = false
	hidden = true
	if Input.is_action_just_pressed("ui_interact") or Input.is_action_just_pressed("ui_jump"):
		hidden = false
		state = NORMAL
		self.show()

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
		moveLeft()
	if (Input.is_action_pressed("ui_right") and crawlRight):
		moveRight()
	
func startGrappling():
	if !global_vars.powers[global_vars.GRAPPLE]:
		return 
		
	state=GRAPPLING
	grapple()

func grappling():
	canFall = true
	if (grapple == null):
		state = NORMAL
	
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
		
func power_up(id):
	global_vars.powers[id] = true
	
func normal(delta):
	canFall = true
	if (Input.is_action_just_pressed("ui_up") && grapple == null):
		startGrappling()
		
	if Input.is_action_just_pressed("ui_interact") and is_on_floor():
		interact()
		
	if Input.is_action_just_pressed("ui_down"):
		smoke_screen()
	
	movement.x = 0
	
	if Input.is_action_pressed("ui_right"):
		moveRight()
		
	if Input.is_action_pressed("ui_left"):
		moveLeft()
	
	
	if !Input.is_action_pressed("ui_jump") and jumping:
		stopJumping()
		
	if Input.is_action_just_pressed("ui_jump"):
		startJumping()
	

func _on_leftArea_body_entered(body):
	crawlLeft = true


func _on_leftArea_body_exited(body):
	crawlLeft = false


func _on_rightArea_body_entered(body):
	crawlRight = true


func _on_rightArea_body_exited(body):
	crawlRight = false


func _on_Interactable_body_entered(body):
	interactable.append(body)


func _on_Interactable_body_exited(body):
	for i in range(len(interactable) - 1):
		if interactable[i] == body:
			interactable.remove(i)
