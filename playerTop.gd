extends KinematicBody2D 
#playerTop.gd
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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
onready var gameScene = get_tree().get_root().get_node("Game")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
#	print(self.get_name())
	print(get_tree().get_root().get_node("Game").get_children()[0].get_children()[0])
	set_process(true);
	set_fixed_process(true);
	set_process_input(true);

	pass

#Runs every frame
func _process(delta):
	movePlayer(delta);
	#groundPhysics()
	CheckPartnerCollision()

	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	
	pass

#merge control on combine
func CheckPartnerCollision():
	if(is_colliding() and get_collider().get_name() == "KinematicPlayerBody" 
	and get_collider().get_global_pos().y < self.get_global_pos().y-20): # colliding with Static, Kinematic, Rigid
		print ("Touching Grey player")
		print ("self:", self.get_global_pos().y)
		print ("touched", get_collider().get_global_pos().y)
		return true
	else:
		return false
	pass

func _input(event):
	
	if(onTopOfPlayer):
		if(event.is_action_pressed("movement_up_Arrow") and canJump):
			canJump = false
			speedY = -JUMPFORCE #Y axis is reverse in game engines
	else:
		if(event.is_action_pressed("movement_up") and canJump):
			canJump = false
			speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass

func setMoveFrom(var transferedY, var transferedX, var inputDirection, var oldDirection, var delta):
	#speedY = transferedY * delta - JUMPFORCE
	#speedX += transferedX
	#input_direction = inputDirection
	 #getprocessdeltatime?
	print("fu")

func movePlayer(var delta):
	#INPUT
	#current direction
	if(input_direction):
		direction = input_direction
	#new direction
	if(Input.is_action_pressed("movement_right")):
		input_direction = 1
	elif(Input.is_action_pressed("movement_left")):
		input_direction = -1
	elif(Input.is_action_pressed("movement_down")):
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
##################end movePlayer()

#TODO:
	#1.Spawn combinedPlayerEntity (spawn player2D for now)
	#2. Delete combinedPlayerEntity on JUMP
	#3. Repeat
	
#rides on Player 2
func OnTop(): 
	canJump = true
	self.set_global_pos(Vector2(get_collider().get_global_pos().x , get_collider().get_global_pos().y-60)) 
	if(!CombinedEntitySpawned): 
		CombinedEntity() #spawn the combined entity when player jumps on top
	
	#spawning the combined entity
func CombinedEntity():
	var PlayerBot = get_parent().get_node("PlayerBot")
	var combinedPlayers = preload("res://CombinedPlayer3.tscn") #get the entity to spawn
	var combinedInstance = combinedPlayers.instance()

	combinedInstance.set_pos(Vector2(PlayerBot.get_global_pos().x,PlayerBot.get_global_pos().y))
	combinedInstance.set_name("PlayerCombined")
	gameScene.add_child(combinedInstance)
	print(combinedInstance.get_parent().get_name())
	get_parent().get_node("PlayerBot").queue_free()
	queue_free()
	print("Combined Entity:", combinedInstance.get_name())
	CombinedEntitySpawned = true
	for i in gameScene.get_children():
		print("child " + str(i) + "'s name: " + i.get_name()) 




func groundPhysics():
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(get_global_pos(), Vector2(get_global_pos().x, 1000), [self])
	if(not result.empty()):
		var collide = result["collider"]
		var distToGround = abs(get_global_pos().y - collide.get_global_pos().y)
		print(distToGround)
		#change this second condition to a group eventually.
		if(distToGround < 43 and collide.get_name() == "platformCollision"):
			#print("dist to ground < 40")
			is_in_air = false
			currentlyColliding = true
			currentCollision = collide
			canJump = true
		else:
			print("dist to ground > 40")
			currentCollision = null
			currentlyColliding = false
			is_in_air = true
			canJump = false
	else:
		is_in_air = true
		currentCollision = null
		print("no result found")

	if(is_in_air):
		gravity = 1000
	else:
		print("not in air")
		gravity = 0
		speedY = 0
	if(currentlyColliding and currentCollision != null and currentCollision.get_name() == "platformCollision"):
		if(currentCollision != null):
			print(currentCollision.get_travel())
			move(currentCollision.get_travel())
	else:
		if(currentCollision == null):
			print("collision is null")
		else:
			print("collision is not null")
		print(gravity)
		print("wat")
