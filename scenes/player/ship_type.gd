extends Node

puppet var ship = "res://scenes/player/test_model"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_ship(ship)

remote func set_ship(path):
	var model = load(path + "/model.tscn")
	get_owner().call_deferred("add_child",model.instance())
	
	var collision = load(path + "/collision.tscn")
	get_owner().call_deferred("add_child",collision.instance())

	var config = load("res://store/config.gd").new(path + "/manifest.cfg")
	
	rset("ship",path)	
	rpc("set_ship",path)
