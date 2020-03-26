extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
master func handle_crashes():
	pass
#	if is_network_master():
#		for i in range(get_owner().get_slide_count() - 1):
#			var collision = get_owner().get_slide_collision(i)
#			if !collision.collider.owner_name && collision.collider.owner_name != get_owner().name:
#				get_owner().health -= pow(2,((float(get_owner().speed)-50)/5))
#		speed to health curve:
#		d:delta, s:speed
#		d(s)=2^((s-50)/5)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
