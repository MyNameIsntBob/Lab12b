extends "res://Scripts/Character.gd"

enum {
	PATROL,
	ATTACK,
	SEARCH
}

const BULLET = preload("res://Prefabs/Bullet.tscn")

var targetPadding = 4

var searchTime = 20
var searchCounter = 0.0
var searchArea = 100

var shootDistance = 80
var shootTimer = 0.0
var shootDelay = 3

var playerInCone
var playerLastPos

var target
var targetPosition

var currentTarget
var currentPath

var patrolArea = []

var wallRight = false
var wallLeft = false


onready var gun = find_node("Gun")
onready var light2D = find_node("Light2D")
onready var pathFinder = find_parent("Master").get_node("PathFinder")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	jumpForce = 150
	jumpTime = 0.5
	moveSpeed = 75
	state = PATROL
	target = 0
	startPatrol()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement.x = 0
	match state: 
		PATROL:
			patrol()
			light2D.color = Color(255, 255, 255)
		ATTACK:
			attack()
			light2D.color = Color(255, 0, 0)
		SEARCH:
			search(delta)
			light2D.color = Color(255, 100, 0)
	
	if shootTimer >= 0:
		shootTimer -= delta
		
	if playerInCone != null:
		targetPlayer()
	light2D.energy = 0.1
	
func goTo(pos):
	if position.distance_to(pos) <= targetPadding:
		return
	
	if (!currentPath or currentPath[-1] != pos) and currentTarget != pos:
		getPath(pos)
	
	if !currentTarget or position.distance_to(currentTarget) <= targetPadding:
		nextPoint() 
	
	if currentTarget:
		if position.x > currentTarget.x:
			moveLeft()
		else:
			moveRight() 
	
func targetPlayer():
	if playerInCone.visible == false:
		return
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, playerInCone.position, [self], collision_mask)
	if (result and result.collider.name == 'Player'):
#		light2D.color = Color(255, 0, 0)
		state = ATTACK
		targetPosition = playerInCone.position
	
func getPath(pos):
	currentPath = pathFinder.findPath(position, pos)
	nextPoint()

func nextPoint():
	if len(currentPath) == 0:
		currentTarget = null
		return
		
	currentTarget = currentPath.pop_front()
	
	if !currentTarget:
		startJumping()
		nextPoint()
	
func nextTarget():
	target += 1
	if target >= len(patrolArea):
		target = 0
	getPath(patrolArea[target])
	targetPosition = patrolArea[target]
	
func lookTowards(location):
	if (location):
		$FlashLight.look_at(location)

func shoot():
	shootTimer = shootDelay
	var bullet = BULLET.instance()
	bullet.set_position(gun.get_global_position())
	bullet.rotation = $FlashLight.rotation
	find_parent("Master").add_child(bullet)
	
func attack():
	lookTowards(targetPosition)
	
	if shootTimer <= 0:
		shoot()
		
	if playerInCone != null:
		targetPlayer()
	
	else:
		startSearch()
	
	if self.position.distance_to(targetPosition) > shootDistance or !self.is_on_floor():
		goTo(targetPosition)

func startPatrol():
	patrolArea = []
	for spot in $Patrol.get_children():
		patrolArea.append(spot.position)
	state = PATROL
	nextTarget()

func patrol():
	lookTowards(targetPosition)
	if targetPosition:
	
		if (position.x > targetPosition.x - targetPadding and position.x < targetPosition.x + targetPadding):
			nextTarget()
		
		goTo(targetPosition)
	
func startSearch():
	searchCounter = searchTime
	state = SEARCH
	targetPosition = playerLastPos
		
	patrolArea = [Vector2(targetPosition.x + searchArea, targetPosition.y), 
		Vector2(targetPosition.x - searchArea, targetPosition.y)]
	
func search(delta):
	lookTowards(targetPosition)
	searchCounter -= delta
	if (searchCounter <= 0):
		startPatrol()
	
	if (position.x > targetPosition.x - targetPadding and position.x < targetPosition.x + targetPadding):
		nextTarget()
	
	goTo(targetPosition)

# If the player eneters the light area
func _on_Area2D_body_entered(body):
	if (body.name == 'Player'):
		playerInCone = body
	pass # Replace with function body.


# If the player leaves the light area
func _on_Area2D_body_exited(body):
	if (body.name == 'Player'):
		playerInCone = null
		playerLastPos = body.position
	pass # Replace with function body.
