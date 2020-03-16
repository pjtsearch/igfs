extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var console = $Console

# Called when the node enters the scene tree for the first time.
func _ready():
	console.connect("visibility_changed",self,"visibility_changed")
	
func visibility_changed():
	if console.visible:
#		print("show")
#		get_tree().paused = true
		pause_handler.pause_movement()
	else:
#		get_tree().paused = false
		pause_handler.resume_movement()


#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == 96:
#			console.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
