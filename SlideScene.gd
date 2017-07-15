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

	yPosition = get_global_pos().y
	if(xPosition != 0):
		var blockMovement = Vector2(-1 * blockMoveSpeed * delta, 0)
		move(blockMovement)
		xPosition = get_global_pos().x
		print("Y pos: " + str(yPosition))
		print("X pos: " + str(xPosition))
		set_global_pos(Vector2(xPosition, get_global_pos().y))
		yPosition = get_global_pos()
	pass