extends Area

var objects = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	objects.clear()
	var overlapping = get_overlapping_bodies()
	for body in overlapping:
		if body != get_owner():
			var body_position = body.get_global_transform().origin
			var self_position = get_global_transform().origin
			var relative_position = body_position - self_position
			objects.append({
				position=relative_position
			})
			
			
