extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var topPlayer = preload("res://PlayerTop.tscn") 
var botPlayer = preload("res://PlayerBot.tscn") 
var canJump = false

var speedX = 0 #X movement speed of player.
var speedY = 0 #Y movement speed of player.

const ACCELERATION = 700 
const DECELERATION = 1000
var gravity = 1000
var velocity = Vector2()
var JUMPFORCE = 400
const MAX_SPEED = 300
var direction = 0
var input_direction = 0
var is_jumping = false
var is_in_air = false
#----
var currentCollision
var currentlyColliding = false
#----

var onTopOfPlayer = false
var CombinedEntitySpawned = false
onready var playerNodeName = null
onready var gameScene = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	pass

func _process(delta):
	movePlayer(delta)
	if(Input.is_action_pressed("movement_up")):
		splitPlayers(delta)

func _input(event):
	print(canJump)
	if(event.is_action_pressed("movement_up_Arrow") and canJump):
		canJump = false
		speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass

func splitPlayers(delta):
	print("split")
	#Split the players up when the top player jumps give both players current momentum?
	var PlayerBot = get_parent().get_node("PlayerBot")
	#get the entity to spawn
	var playerBotInstance = botPlayer.instance()
	var playerTopInstance = topPlayer.instance()
	print(get_node("Sprite").get_region_rect())
	playerBotInstance.set_pos(get_global_pos())
	playerBotInstance.set_name("PlayerBot")
	var test2 = get_node("Sprite").get_texture().get_height()
	playerTopInstance.set_pos(Vector2(get_global_pos().x, get_global_pos().y - test2 + 40))
	playerTopInstance.set_name("PlayerTop")
	gameScene.add_child(playerTopInstance)
	gameScene.add_child(playerBotInstance)
	var newPlayerTop = gameScene.get_node("PlayerTop")
	newPlayerTop.setMoveFrom(speedY, speedX , input_direction, direction, delta)

	queue_free()

func movePlayer(var delta):
	#INPUT
	#current direction
	if(input_direction):
		direction = input_direction
	#new direction
	if(Input.is_action_pressed("movement_right_Arrow")):
		input_direction = 1
	elif(Input.is_action_pressed("movement_left_Arrow")):
		input_direction = -1
	elif(Input.is_action_pressed("movement_down_Arrow")):
		print("down button pressed")
	else:
		input_direction = 0 #not moving.
	
	#MOVEMENT
	if input_direction == -direction: #moving opposite way
		speedX /= 3
	if input_direction:
		speedX += ACCELERATION * delta
	else:
		speedX -= DECELERATION * delta
	
	speedY += gravity * delta #Y movement speed.
	velocity.y = speedY * delta #
	speedX = clamp(speedX, 0, MAX_SPEED) #Clamp - if first param lower than 0. it will set to 2nd param. If higher than MAX_SPEED will set to set to 3rd param
	velocity.x = speedX * delta * direction
	var moveLeft = move(velocity)
	if(is_colliding()):
		var normal = get_collision_normal() #vector pointing up from ground.
		var finalMove = normal.slide(moveLeft) #slide removes part of movement that makes character collide
		var yPositionOther = get_collider().get_global_pos().y 
		var yPositionSelf = self.get_global_pos().y
		#check who its collider is
		if(get_collider().get_name() == "platformCollision"): 
			onTopOfPlayer= false
			canJump = true
		
		if(get_collider().get_name() == "PlayerBot" and yPositionSelf+50 < yPositionOther): 
			onTopOfPlayer= true
			OnTop()
		else: CombinedEntitySpawned = false
		#combine the 2 object together
		
		speedY = normal.slide(Vector2(0, speedY)).y
		move(finalMove)
	pass