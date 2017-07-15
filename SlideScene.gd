extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var blockMoveSpeed = 100
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
	if(xPosition != 0):
		print("Xpos not null")
		print("xPos: " + str(xPosition))
		move(Vector2(-1 * blockMoveSpeed * delta, 0))
	pass