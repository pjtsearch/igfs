extends Node

signal set

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var data = {}
# Called when the node enters the scene tree for the first time.

func get_value(section,item,default):
	if data[section].has(item):
		return data[section][item]
	else:
		return default
	
func set_value(section,item,value):
	data[section][item] = value
	emit_signal("set",section,item,value)
	
func erase_section(section):
	data.erase(section)

func get_section_keys(section):
	return data[section].keys()
	
func get_sections():
	return data.keys()
	
func has_section(section):
	return data.has(section)
	
func has_section_key(section,key):
	return data[section].has(key)
