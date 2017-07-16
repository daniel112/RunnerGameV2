extends KinematicBody2D 
<<<<<<< HEAD

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

=======
#playerBot.gd
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var canJump = false
>>>>>>> Ryan-Branch

var speedX = 0 #X movement speed of player.
var speedY = 0 #Y movement speed of player.

const ACCELERATION = 700 
const DECELERATION = 1000
<<<<<<< HEAD
const GRAVITY = 1000
=======
var gravity = 1000
>>>>>>> Ryan-Branch
var velocity = Vector2()
var JUMPFORCE = 400
const MAX_SPEED = 300
var direction = 0
var input_direction = 0
var is_jumping = false
<<<<<<< HEAD
#onready var ground_ray = get_node("Ground_Ray")
#onready var ground_ray1 = get_node("Ground_Ray1")
#onready var ground_ray2 = get_node("Ground_Ray2")
#onready var ground_ray_arr = [ground_ray, ground_ray1, ground_ray2]

onready var _player = null
=======
var is_in_air = false
#----
var currentCollision
var currentlyColliding = false
#----

onready var playerNodeName = null
>>>>>>> Ryan-Branch

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
<<<<<<< HEAD
	_player = get_node("PlayerBody") # for debugging
#	print(self.get_name())
	
=======
#	print(self.get_name())
	print(get_tree().get_root().get_node("Game").get_children()[0].get_children()[0])
>>>>>>> Ryan-Branch
	set_process(true);
	set_fixed_process(true);
	set_process_input(true);

	pass

#Runs every frame
func _process(delta):
	movePlayer(delta);
<<<<<<< HEAD
	CheckPartnerCollision()

=======
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(get_global_pos(), Vector2(get_global_pos().x, 1000), [self])
	if(not result.empty()):
		#print(result["position"])
		var collide = result["collider"]
		var distToGround = abs(get_global_pos().y - collide.get_global_pos().y)
		#print(distToGround)
		#print(collide.get_name())
		#change this second condition to a group eventually.
		if(distToGround < 43 and collide.get_name() == "platformCollision"):
			#print("dist to ground < 40")
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
		currentCollision = null
		print("no result found")
	if(is_in_air):
		gravity = 1000
	else:
		#print("not in air")
		gravity = 0
		speedY = 0


	if(currentlyColliding and currentCollision != null and currentCollision.get_name() == "platformCollision"):
		if(currentCollision != null):
			print(currentCollision.get_travel())
			move(currentCollision.get_travel())
	else:
		print("wat")
>>>>>>> Ryan-Branch
	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	
	pass

<<<<<<< HEAD
#func is_touching_ground():
#	var ray_is_colliding = false
#	for i in ground_ray_arr:
#		if(i.is_colliding()):
#			ray_is_colliding = true
#		#print(i.is_colliding())
#	return ray_is_colliding

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
	if(event.is_action_pressed("movement_up_Arrow") and is_jumping==false):
		is_jumping = true
		speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass

func can_jump():
		var platformCollider = get_node("/root/Game/platform") #get collider platform object
#		print(test.get_name())
		if(self.is_colliding()):
			print(get_collider().get_name())
			var collidingWith = get_collider()
			if(collidingWith == "platform"): print("YYYY", collidingWith)


func movePlayer(var delta):
	
	
	if(self.is_colliding()):
		print(get_collider())
	
	if(self.is_colliding() and get_collider().get_name() == "platform"): print("TOUCHING PLATFORM" )
	
	#set the value of y when touching the ground to prevent stutter
#	if(self.get_pos().y >= 428): self.set_pos(Vector2(self.get_pos().x,428)); 
#		print(self.get_pos())
=======


func _input(event):
	if(event.is_action_pressed("movement_up_Arrow") and canJump==true):
		canJump = false
		speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass


func movePlayer(var delta):

>>>>>>> Ryan-Branch
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
	
	
<<<<<<< HEAD
	speedY += GRAVITY * delta #Y movement speed.
=======
	speedY += gravity * delta #Y movement speed.
>>>>>>> Ryan-Branch
	velocity.y = speedY * delta #
	speedX = clamp(speedX, 0, MAX_SPEED) #Clamp - if first param lower than 0. it will set to 2nd param. If higher than MAX_SPEED will set to set to 3rd param
	velocity.x = speedX * delta * direction
	var moveLeft = move(velocity)

	if(is_colliding()):
<<<<<<< HEAD
=======
		print(get_collider())
>>>>>>> Ryan-Branch
		var normal = get_collision_normal() #vector pointing up from ground.
		var finalMove = normal.slide(moveLeft) #slide removes part of movement that makes character collide
		speedY = normal.slide(Vector2(0, speedY)).y
		move(finalMove)
	pass
##################end movePlayer()