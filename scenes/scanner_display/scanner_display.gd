extends Control

var scanner_sprite = preload("res://scenes/scanner_sprite/scanner_sprite.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in get_node("scanner_viewport").get_children():
		child.queue_free()
		
	var objects = get_node("/root/igfs/children/world/objects/player_"+str(get_tree().get_network_unique_id())+"/scanner_area").objects
#	var relative_objects = [];
	for object in objects:
#		var relative_x = (object.position.x / 500) * 150
#		var relative_y = (object.position.y / 500) * 150
		var new_object = Dictionary(object).duplicate(true)
#											width of scanner_display
#													|
#											   		v
		var relative_position = (object.position * 150)*Vector2(-1,1)+Vector2(75,75)
		new_object.position = relative_position
#		relative_objects.append(new_object)
		var sprite = scanner_sprite.instance()
		sprite.position = relative_position
		get_node("scanner_viewport").add_child(sprite)
#	print(relative_objects)
