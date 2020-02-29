extends Spatial

var player = preload("res://scenes/player/player.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var instance_player = player.instance()
	add_child(instance_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
