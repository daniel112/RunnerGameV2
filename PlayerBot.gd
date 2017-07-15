extends KinematicBody2D 

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


var speedX = 0 #X movement speed of player.
var speedY = 0 #Y movement speed of player.

const ACCELERATION = 700 
const DECELERATION = 1000
const GRAVITY = 1000
var velocity = Vector2()
var JUMPFORCE = 400
const MAX_SPEED = 300
var direction = 0
var input_direction = 0
var is_jumping = false
#onready var ground_ray = get_node("Ground_Ray")
#onready var ground_ray1 = get_node("Ground_Ray1")
#onready var ground_ray2 = get_node("Ground_Ray2")
#onready var ground_ray_arr = [ground_ray, ground_ray1, ground_ray2]

onready var _player = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	_player = get_node("PlayerBody") # for debugging
#	print(self.get_name())
	
	set_process(true);
	set_fixed_process(true);
	set_process_input(true);

	pass

#Runs every frame
func _process(delta):
	movePlayer(delta);
	CheckPartnerCollision()

	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	
	pass

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
	
	
	speedY += GRAVITY * delta #Y movement speed.
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