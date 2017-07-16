extends Node2D

#this class will need to pick a random "level" scene from a list of level scenes and 
#spawn them on a timer.


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ground_scene = preload("res://Level1Test.tscn")
onready var LeaveCameraView = get_node("LeaveCameraViewPos")
onready var gameScene = get_parent()
onready var test = get_node("container")
const NUMSTARTINGLEVELS = 2 #2 Might not work...
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for i in range(NUMSTARTINGLEVELS):
		spawnNewLevel()
		moveToNewSpawnPos()
	print(ground_scene)
	pass


func spawnNewLevel():
	var ground_instance = ground_scene.instance()
	ground_instance.set_pos(get_global_pos())
	ground_instance.connect("levelDestroyed", self, "spawnNewLevel")
	ground_instance.connect("levelDestroyed", self, "moveToNewSpawnPos")
	test.add_child(ground_instance)
	#set_global_pos(Vector2(get_global_pos().x + 1024, get_global_pos().y))



func moveToNewSpawnPos():
	set_global_pos(Vector2(get_global_pos().x + 1024, get_global_pos().y))