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
var currentCollisionY
var currentCollisionX
var currentlyCollidingX = false
var currentlyCollidingY = false
var canMoveRight = true
#----

onready var playerNodeName = null

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
	groundPhysics()
	#Eventually once we have more time we should do collision detection based on if they "will collide" rather than if they are
	#Currently colliding.
	#Creation of collisions infront of player detection.
	
	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	
	pass



func _input(event):
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
		canMoveRight = true
		speedX -= DECELERATION * delta
	
	
	speedY += gravity * delta #Y movement speed.
	velocity.y = speedY * delta #
	speedX = clamp(speedX, 0, MAX_SPEED) #Clamp - if first param lower than 0. it will set to 2nd param. If higher than MAX_SPEED will set to set to 3rd param
	if(canMoveRight):
		velocity.x = speedX * delta * direction
	elif(!canMoveRight and !input_direction):
		velocity.x = speedX * delta * direction
	else:
		velocity.x = 0
	var moveLeft = move(velocity)

	if(is_colliding()):
		print(get_collider())
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
		print("this: " + str(collide.get_name()))
		var distToGround = abs(get_global_pos().y - collide.get_global_pos().y)
		print(distToGround)
		#change this second condition to a group eventually.
		print("dist to ground: " + str(distToGround))
		if(distToGround < 43 and collide.get_name() == "platformCollision"):
			#print("dist to ground < 40")
			is_in_air = false
			currentlyCollidingY = true
			currentCollisionY = collide
			canJump = true
		else:
			#print("dist to ground > 40")
			currentCollisionY = null
			currentlyCollidingY = false
			is_in_air = true
			canJump = false
	else:
		is_in_air = true
		currentCollisionY = null
		#print("no result found")
	if(is_in_air):
		gravity = 1000
	else:
		#print("not in air")
		gravity = 0
		speedY = 0
	if(currentlyCollidingY and currentCollisionY != null and currentCollisionY.get_name() == "platformCollision"):
		if(currentCollisionY != null):
			print(currentCollisionY.get_travel())
			move(currentCollisionY.get_travel())
	else:
		if(currentCollisionY == null):
			print("collision is null")
		else:
			print("collision is not null")
			#print(gravity)
			#print("wat")
