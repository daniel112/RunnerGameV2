extends KinematicBody2D 
#playerBot.gd
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

onready var playerNodeName = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	print(self.get_name())


#	print(self.get_name())
	print(get_parent().get_node("PlayerTop").get_name())

	set_process(true);
	set_fixed_process(true);
	set_process_input(true);

	pass

#Runs every frame
func _process(delta):
	movePlayer(delta);
	groundPhysics()
	#Eventually once we have more time we should do collision detection based on if they "will collide" rather than if they are
	#Currently colliding.
	#Creation of collisions infront of player detection.
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(get_global_pos(), Vector2(1000, get_global_pos().y), [self])
	if(not result.empty()):
		print(result["collider"])
		var coll = result["collider"]
		print(coll.get_name())
		var distToObstacle = abs(coll.get_global_pos().x - get_global_pos().x)
		if(distToObstacle < 22):
			print("dist to obstacle is: " + str(distToObstacle))
			move(coll.get_travel() * 2)
		else:
			print("not close enough")
	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	
	pass

#TODO:
	#change spawned entity to both. and white jumping
func SplitEntity():
	var combinedPlayers = preload("res://Player2D.tscn") #get the entity to spawn
	var combinedInstance = combinedPlayers.instance()

	combinedInstance.set_pos(Vector2(self.get_global_pos().x,self.get_global_pos().y))
	combinedInstance.set_name("PlayerTop")
	get_parent().add_child(combinedInstance)
	
	self.queue_free()

func _input(event):
	
	#if W is pressed (white jump) while entity is combined- split them up
	if(self.get_name() == "PlayerCombined" and event.is_action_pressed("movement_up")):
		SplitEntity()
	if(event.is_action_pressed("movement_up_Arrow") and canJump==true):
		canJump = false
		speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass


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
		speedY = normal.slide(Vector2(0, speedY)).y
		move(finalMove)
	pass
##################end movePlayer()
func groundPhysics():

	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(get_global_pos(), Vector2(get_global_pos().x, 1000), [self])
	if(not result.empty()):
		#print(result["position"])
		var collide = result["collider"]

		var distToGround = abs(get_global_pos().y - collide.get_global_pos().y)

		print(collide.get_name())
		var distToGround = abs(get_children()[0].get_global_pos().y - collide.get_global_pos().y)
		print("dist to ground: " + str(distToGround))

		#print(collide.get_name())
		#change this second condition to a group eventually.
		if(distToGround < 43 and collide.get_name() == "platformCollision"):
			
#				print("dist to ground < 40")
			is_in_air = false
			currentlyColliding = true
			currentCollision = collide
			canJump = true
		else:

			#print("dist to ground > 40")

			currentCollision = null
			currentlyColliding = false
			is_in_air = true
			canJump = false
	else:
		is_in_air = true
		currentCollision = null


	if(is_in_air):
		gravity = 1000
	else:

		gravity = 0
		speedY = 0
	if(currentlyColliding and currentCollision != null and currentCollision.get_name() == "platformCollision"):
		if(currentCollision != null):
			move(currentCollision.get_travel())

			#print(currentCollision.get_travel())
			move(currentCollision.get_travel())
	else:
		if(currentCollision == null):
			print("collision is null")
		else:
			print("collision is not null")
		#print(gravity)
		#print("wat")
