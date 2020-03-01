extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
puppet var puppet_position = Transform(Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0))

var speed = 0
var health = 100
var landing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if is_network_master():
		var collisionInfo = move_and_slide(global_transform.basis.z * -1 * speed)
		rset_unreliable('puppet_position', get_global_transform())
	else:
		set_global_transform(puppet_position)


master func transition_rotate(speed,vector):
	var rotate_transiton = transition_handler.transition(speed,0,100,1.07)
	for amount in rotate_transiton:
		rotate_object_local(vector, amount)
		yield( get_tree().create_timer(0.05), "timeout" )
