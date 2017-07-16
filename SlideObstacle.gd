extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var blockMoveSpeed = 15
var xPosition
var yPosition

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	print("test")
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	moveGround(delta)
	pass

func moveGround(delta):
	xPosition = get_global_pos().x
	yPosition = get_global_pos().y
	if(xPosition != 0):
		var blockMovement = Vector2(-2 * blockMoveSpeed * delta, 0)
		move(blockMovement)
		#print("Y pos: " + str(yPosition))
		#print("X pos: " + str(xPosition))
	pass