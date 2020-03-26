extends Spatial

var bullet = preload("res://scenes/bullet/bullet.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SHIP_TURN_RATE = 0.1
var SHIP_MAX_SPEED = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


master func _process(delta):
#
#	var SHIP_TURN_RATE = ShipInfo.ships[ShipInfo.ship].turn_rate
#	var SHIP_MAX_SPEED = ShipInfo.ships[ShipInfo.ship].max_speed
#
#	var TURN_SPEED = get_turn_speed(delta,get_owner().speed,SHIP_TURN_RATE)
	
	var TURN_SPEED = 0.01
	if !pause_handler.movement_paused:
		if Input.is_key_pressed(KEY_UP):
	#		if get_owner().speed + 1 <= SHIP_MAX_SPEED && !get_owner().landing:
	#			get_owner().speed = get_owner().speed+1
	#		elif get_owner().landing:
	#			var body_in_landing = $"../LandingRay".is_colliding()
	#			if body_in_landing:
	#				get_owner().move_and_collide(get_owner().global_transform.basis.y * 1 * 0.1)
			get_owner().speed = get_owner().speed+1
		if Input.is_key_pressed(KEY_DOWN):
	#		if abs(get_owner().speed - 1) <= SHIP_MAX_SPEED && !get_owner().landing:
	#			get_owner().speed = get_owner().speed-1
	#		elif get_owner().landing:
	#			var body_in_landing = $"../LandingRay".is_colliding()
	#			if body_in_landing:
	#				get_owner().move_and_collide(get_owner().global_transform.basis.y * -1 * 0.1)
			get_owner().speed = get_owner().speed-1
		if Input.is_key_pressed(KEY_S):
			if !get_owner().landing:
				get_owner().transition_rotate(-TURN_SPEED,Vector3(1, 0, 0))
			else:
				get_owner().transition_rotate(-(delta * (SHIP_TURN_RATE * 10)),Vector3(1, 0, 0))
		if Input.is_key_pressed(KEY_W):
			if !get_owner().landing:
				get_owner().transition_rotate(TURN_SPEED,Vector3(1, 0, 0))
			else:
				get_owner().transition_rotate(delta * (SHIP_TURN_RATE * 10),Vector3(1, 0, 0))
		if Input.is_key_pressed(KEY_A):
			if !get_owner().landing:
				get_owner().transition_rotate(TURN_SPEED,Vector3(0, 1, 0))
			else:
				get_owner().transition_rotate(delta * (SHIP_TURN_RATE * 10),Vector3(0, 1, 0))
		if Input.is_key_pressed(KEY_D):
			if !get_owner().landing:
				get_owner().transition_rotate(-TURN_SPEED,Vector3(0, 1, 0))
			else:
				get_owner().transition_rotate(-(delta * (SHIP_TURN_RATE * 10)),Vector3(0, 1, 0))
		if Input.is_key_pressed(KEY_Q):
			if !get_owner().landing:
				get_owner().transition_rotate(-TURN_SPEED,Vector3(0, 0, 1))
			else:
				get_owner().transition_rotate(-(delta * (SHIP_TURN_RATE * 10)),Vector3(0, 0, 1))
	
		if Input.is_key_pressed(KEY_E):
			if !get_owner().landing:
				get_owner().transition_rotate(TURN_SPEED,Vector3(0, 0, 1))
			else:
				get_owner().transition_rotate(delta * (SHIP_TURN_RATE * 10),Vector3(0, 0, 1))

#FIXME: REFACTOR

master func _unhandled_input(event):
	if is_network_master():
		if !pause_handler.movement_paused:
			if event is InputEventKey:
				if event.pressed and event.scancode == KEY_SPACE:
					var instance_bullet = bullet.instance()
					randomize()
					var id = randi()%100000000001+1
					instance_bullet.set_name("bullet_"+str(id))
					instance_bullet.set_network_master(get_tree().get_network_unique_id())
					instance_bullet.speed = get_owner().speed + 1000
					instance_bullet.set_global_transform(get_owner().get_global_transform())
					instance_bullet.owner_name = name
#					make sure bullet doesn't hit the ship when it is spawned at high speeds
#					var speed_compensation = -81.4 * (pow(0.99989,0.999*(get_owner().speed-100))) + 80.2
#					if speed_compensation < 0: speed_compensation = 0
					instance_bullet.translate(Vector3(0,0,0))
					#print("_unhandled_input add_child")
					$"/root/igfs/children/world/objects".add_child(instance_bullet)
					
#					print("--register_object id:"+str(id))
					network.rpc("register_object",  get_tree().get_network_unique_id(), "bullet", {id=id})
					yield(get_tree().create_timer(10), "timeout")
					if has_node("/root/igfs/children/world/objects/bullet_"+str(id)):
						get_node("/root/igfs/children/world/objects/bullet_"+str(id)).queue_free()
					else:
						print_debug("doesnt have node:"+"/root/igfs/children/world/objects/bullet_"+str(id))
					network.rpc("unregister_object",  "bullet_"+str(id))
				
				if event.pressed and event.scancode == KEY_R:
					get_owner().reset()
