extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var config = ConfigFile.new()
var path = "res://settings.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()

func load_config():
	config.load(path)
	
func save():
	config.save(path)
	
func get_value(section,item,default):
	return config.get_value(section,item,default)
	
func set_value(section,item,value):
	config.set_value(section,item,value)
	save()
	
func erase_section(section):
	config.erase_section(section)
	save()

func get_section_keys(section):
	config.get_section_keys(section)
	save()
	
func get_sections():
	return config.get_sections()
	
func has_section(section):
	return config.has_section(section)
	
func has_section_key(section,key):
	return config.has_section_key(section,key)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
