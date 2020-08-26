extends KinematicBody2D

enum {
	PATROL,
	ATTACK,
	SEARCH
}

const BULLET = preload("res://Prefabs/Bullet.tscn")

var jumpForce = 400
var gravity = 20
var moveSpeed = 50
var targetPadding = 0.5

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
var state = PATROL
var movement

var patrolArea = []

var wallRight = false
var wallLeft = false

var gun

# Called when the node enters the scene tree for the first time.
func _ready():
	gun = find_node("Gun")
	target = 0
	startPatrol()
	movement = Vector2(0, 0)
#	target = 0
#	targetPosition = get_node("Patrol").get_child(target).position
	pass # Replace with function body.

func moveLeft():
	if (wallLeft):
		jump()
	movement.x = -moveSpeed
	
func moveRight():
	if (wallRight):
		jump()
	movement.x = moveSpeed

func jump():
	if (self.is_on_floor()):
		movement.y = -jumpForce
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var light2D = find_node("Light2D")
	
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
	
	if (!self.is_on_floor()):
		movement.y += gravity
		
	if playerInCone != null:
		targetPlayer()
	light2D.energy = 0.1
	
	self.move_and_slide(movement, Vector2(0, -1))
	
func targetPlayer():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, playerInCone.position, [self], collision_mask)
	if (result and result.collider.name == 'Player'):
#		light2D.color = Color(255, 0, 0)
		state = ATTACK
		targetPosition = playerInCone.position
	
func nextTarget():
	target += 1
	if target >= len(patrolArea):
		target = 0
	targetPosition = patrolArea[target]
	
func lookTowards(location):
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
		if position.x > targetPosition.x:
			moveLeft()
		else:
			moveRight()
	else:
		movement.x = 0
		pass
#		Shoot

func startPatrol():
	patrolArea = []
	for spot in $Patrol.get_children():
		patrolArea.append(spot.position)
	state = PATROL
	nextTarget()

func patrol():
	lookTowards(targetPosition)
	
	if (position.x > targetPosition.x - targetPadding and position.x < targetPosition.x + targetPadding):
		nextTarget()
	
	if position.x > targetPosition.x:
		moveLeft()
	else:
		moveRight()
	pass
	
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
	
	if position.x > targetPosition.x:
		moveLeft()
	else:
		moveRight()

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


func _on_FrontArea_body_entered(body):
	wallRight = true
	pass # Replace with function body.

func _on_FrontArea_body_exited(body):
	wallRight = false
	pass # Replace with function body.

func _on_BackArea_body_entered(body):
	wallLeft = true
	pass # Replace with function body.

func _on_BackArea_body_exited(body):
	wallLeft = false
	pass # Replace with function body.

func _on_GroundArea_body_exited(body):
	if (targetPosition.y <= self.position.y + 10):
		jump()
	pass # Replace with function body.









