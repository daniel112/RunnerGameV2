extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var spawned = false
var ground_scene = preload("res://GroundNode.tscn")
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(!spawned):
		var ground_instance = ground_scene.instance()
		ground_instance.set_pos(get_parent().get_global_pos())
		spawned = true
	pass