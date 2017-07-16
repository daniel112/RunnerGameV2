extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scrollspeed = 100


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	set_pos(Vector2(get_pos().x + (delta * scrollspeed), get_pos().y)) 
	pass

func getOffSet():
	return get_pos() - get_offset()