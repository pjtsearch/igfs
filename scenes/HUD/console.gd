extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var console = $Console

# Called when the node enters the scene tree for the first time.
func _ready():
	console.connect("visibility_changed",self,"visibility_changed")
	console.userName = network.my_info.id
	
	var say_ref = CommandRef.new(self, "say", CommandRef.VARIANT)
	var say_command = ConsoleCommand.new('say', say_ref , 'Say to other players.')
	console.add_command(say_command)
	
func visibility_changed():
	if console.visible:
#		print("show")
#		get_tree().paused = true
		pause_handler.pause_movement()
	else:
#		get_tree().paused = false
		pause_handler.resume_movement()

remote func write_message(name,message):
	console.write_line("")
	console.write_line(format_message(name,message))
	
func say(args):
	var message = PoolStringArray(args).join(" ")
	console.write_line("")
	console.write_line(format_message(network.my_info.name,message))
#	if console.selectedChannel == "All":
	rpc("write_message",network.my_info.name,message)
	
func format_message(name,message):
	return console.get_time_stamp(false)+"> [color=#0000ff]"+name+ "[/color]: "+message

#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == 96:
#			console.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
