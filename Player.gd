extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player
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

var test = 0
onready var ground_ray = get_node("Ground_Ray")
onready var ground_ray1 = get_node("Ground_Ray1")
onready var ground_ray2 = get_node("Ground_Ray2")
onready var ground_ray_arr = [ground_ray, ground_ray1, ground_ray2]
onready var player_body = get_node("PlayerBody")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for i in ground_ray_arr:
		i.get_name()
	#print("test");
	set_process(true);
	set_fixed_process(true);
	set_process_input(true);
	pass

#Runs every frame
func _process(delta):
	movePlayer(delta);
	#print(player_body.get_item_and_children_rect())
	#print(get_item_and_children_rect())
	
	pass

#Runs at a fixed frame. 
func _fixed_process(delta):
	#print(player_body.get_global_pos())
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(player_body.get_global_pos(), Vector2(ground_ray.get_global_pos().x, 1000), [self])
	
	if(not result.empty()):
		if(abs(result["position"].y - get_global_pos().y) < 25):
			#print(true)
			test = 1
		else:
			test = 1
			#print("y pos for result is" + str(result["position"].y))
			#print("y pos for kinematic body is" + str(get_global_pos().y))
			#print(clamp(abs(result["position"].y - get_global_pos().y), 0, 1000))
	else:
		print("no result")

func is_touching_ground():
	var ray_is_colliding = false
	for i in ground_ray_arr:
		if(i.is_colliding()):
			ray_is_colliding = true
		#print(i.is_colliding())
	return ray_is_colliding

func _input(event):
#	print(is_touching_ground())
	if(event.is_action_pressed("movement_up") and is_touching_ground()):
		is_jumping = true #not being used atm
		speedY = -JUMPFORCE #Y axis is reverse in game engines
	pass

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
	
	speedY += GRAVITY * delta #Y movement speed.
	velocity.y = speedY * delta #
	speedX = clamp(speedX, 0, MAX_SPEED) #Clamp - if first param lower than 0. it will set to 2nd param. If higher than MAX_SPEED will set to set to 3rd param
	velocity.x = speedX * delta * direction
	var moveLeft = move(velocity)

	if(is_colliding()):
		if(get_collider().get_name() == "PlayerBot" ): print("SDFSDFS")
		var normal = get_collision_normal() #vector pointing up from ground.
		var finalMove = normal.slide(moveLeft) #slide removes part of movement that makes character collide
		speedY = normal.slide(Vector2(0, speedY)).y
		move(finalMove)
		