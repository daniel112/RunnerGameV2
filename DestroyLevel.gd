extends Node2D

#this class will need to pick a random "level" scene from a list of level scenes and 
#spawn them on a timer.


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var EndLevel = get_node("EndLevelPos")
onready var gameScene = get_tree().get_root().get_node("Game")
onready var camera = gameScene.get_node("Camera2D")
var didEmit = false
signal levelDestroyed
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	print("CAMERA COORDS: " + str(camera.get_global_pos()))
	print("End of level COORDS: " + str(EndLevel.get_global_pos()))
	if(EndLevel.get_global_pos().x < camera.get_pos().x and !didEmit):
		emit_signal("levelDestroyed")
		didEmit = true
	if(EndLevel.get_global_pos().x + 150 < camera.get_pos().x):
		queue_free()
	pass