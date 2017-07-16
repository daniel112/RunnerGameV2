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
	yPosition = get_global_pos().y
	if(xPosition != 0):
		var blockMovement = Vector2(-1 * blockMoveSpeed * delta, 0)
		var moveLeft = move(blockMovement)
		if(is_colliding()):
			if(get_collider().get_name() == "PlayerBot"):
				print("yes")
				print("kill: " + get_tree().get_root().get_node("Game").get_children()[3].get_name())
				get_tree().get_root().get_node("Game").get_children()[3].queue_free()
	pass