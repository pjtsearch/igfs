extends KinematicBody

puppet var puppet_position = Transform(Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0))

var speed = 100
var damage = 10
var owner_name = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(5), "timeout")
	destroy()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func destroy():
	network.rpc("unregister_object", name)	
	queue_free()

func _process(delta):
	if is_network_master():
		var collisionInfo = move_and_collide(global_transform.basis.z * 1 * speed/25)
		rset_unreliable('puppet_position', get_global_transform())
		if collisionInfo:
			rset('puppet_position', get_global_transform())
			#FIXME: wait until other players send a signal back that it collided, instead of doing a timer
			yield(get_tree().create_timer(0.15), "timeout")			
			destroy()
	else:
		set_global_transform(puppet_position)		
		var collisionInfo = move_and_collide(global_transform.basis.z * 1 * 0)
		if collisionInfo:
#			print(collisionInfo.collider.name)
			collisionInfo.collider.on_bullet_hit(damage)
