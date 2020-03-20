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
			var collision_shape_radius = $CollisionShape.shape.radius
#																CollisionShape size
#																	  v
			var relative_position = (body_position - self_position)/ collision_shape_radius
			relative_position = rotate_point(relative_position,Vector3(0,0,0),get_owner().global_transform.basis.get_euler().y)
			objects.append({
				position=relative_position
			})
			
func rotate_point(point, center, angle):
	
	var rotatedX = cos(angle) * (point.x - center.x) - sin(angle) * (point.z-center.z) + center.x;
	
	var rotatedZ = sin(angle) * (point.x - center.x) + cos(angle) * (point.z - center.z) + center.z;
	
	return Vector2(rotatedX,rotatedZ);

			
