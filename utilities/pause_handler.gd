extends Node

signal pause_movement
signal resume_movement

signal pause
signal resume

var paused = false
var movement_paused = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pause():
	get_tree().paused = true
	paused = true
	emit_signal("pause")

func resume():
	get_tree().paused = false
	paused = false	
	emit_signal("resume")
	
func pause_movement():
	movement_paused = true
	emit_signal("pause_movement")
	
func resume_movement():
	movement_paused = false
	emit_signal("resume_movement")
