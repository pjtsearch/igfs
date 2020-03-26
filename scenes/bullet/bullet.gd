extends KinematicBody

puppet var puppet_position = Transform(Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0))

var speed = 100
var owner_name = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if is_network_master():
		var collisionInfo = move_and_slide(global_transform.basis.z * 1 * speed)
		rset_unreliable('puppet_position', get_global_transform())
	else:
		set_global_transform(puppet_position)
