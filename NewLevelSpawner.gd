extends Node2D

#this class will need to pick a random "level" scene from a list of level scenes and 
#spawn them on a timer.


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ground_scene = [
preload("res://Level2Test.tscn"),
preload("res://Level1Test.tscn")
]
onready var LeaveCameraView = get_node("LeaveCameraViewPos")
onready var gameScene = get_parent()
onready var test = get_node("container")
var test2 = false
const NUMSTARTINGLEVELS = 2 #2 Might not work...
func _ready():
	#set_process(true)
	# Called every time the node is added to the scene.
	# Initialization here
	for i in range(NUMSTARTINGLEVELS):
		spawn_and_move()
	print(ground_scene)
	pass

func _process(delta):
	for i in get_node("container").get_children():
		print("container has " + i.get_name())

func spawnNewLevel():
	var ground_instance = ground_scene[rand_range(0,2)].instance()
	ground_instance.set_pos(get_global_pos())
	ground_instance.connect("levelDestroyed", self, "spawn_and_move")
	test.add_child(ground_instance)
	#set_global_pos(Vector2(get_global_pos().x + 1024, get_global_pos().y))

func spawn_and_move():
	spawnNewLevel()
	moveToNewSpawnPos()

func moveToNewSpawnPos():
	set_global_pos(get_pos() + Vector2(1024, 0))