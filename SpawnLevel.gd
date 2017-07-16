extends Position2D

#this class will need to pick a random "level" scene from a list of level scenes and 
#spawn them on a timer.


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var spawned = false
var ground_scene = preload("res://Level1Test.tscn")
#var ground_scene = preload("res://GroundNode.tscn")
onready var gameScene = get_parent()
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(!spawned):
		var ground_instance = ground_scene.instance()
		print(gameScene.get_name())
		print(ground_instance.get_name())
		gameScene.add_child(ground_instance)
		#the below is unnecessary as it can be set in the GroundNode.tscn
		#var child1 = ground_instance.get_children()[0] #get children returns an array of objects
		#child1.set_layer_mask(10)
		ground_instance.set_pos(get_global_pos())
		print(ground_instance.get_global_pos())
		spawned = true
	pass