extends Position2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var spawned = false
var ground_scene = preload("res://GroundNode.tscn")
onready var gameScene = get_parent()
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(!spawned):
		print("can instance" + str(ground_scene.can_instance()))
		var ground_instance = ground_scene.instance()
		gameScene.add_child(ground_instance)
		#the below is unnecessary as it can be set in the GroundNode.tscn
		#var child1 = ground_instance.get_children()[0] #get children returns an array of objects
		#child1.set_layer_mask(10)
		ground_instance.set_pos(get_global_pos())
		spawned = true
	pass