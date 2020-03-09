extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
master func handle_crashes():
	if is_network_master() && get_owner().get_slide_count():
#		speed to health curve:
#		d:delta, s:speed
#		d(s)=2^((s-50)/5)
		get_owner().health -= pow(2,((float(get_owner().speed)-50)/5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
