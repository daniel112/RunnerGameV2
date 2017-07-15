extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_node(".")
	print("test");
	set_process(true);
	pass

func _process(delta):
	move(delta);
	pass


func move(var delta):
	print("test2")
	if(Input.is_action_pressed("movement_up")):
		add_force(player.get_pos(), Vector2(0,10))
		