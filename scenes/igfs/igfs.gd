extends Node

var main_menu = preload("res://scenes/main_menu/main_menu.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var instance_main_menu = main_menu.instance()
	add_child(instance_main_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
