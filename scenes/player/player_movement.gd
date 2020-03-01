extends Spatial


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
	
	var TURN_SPEED = 0.1

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
		# rotate_object_local(Vector3(1, 0, 0), TURN_SPEED)
		if !get_owner().landing:
			get_owner().transition_rotate(TURN_SPEED,Vector3(1, 0, 0))
		else:
			get_owner().transition_rotate(delta * (SHIP_TURN_RATE * 10),Vector3(1, 0, 0))
	if Input.is_key_pressed(KEY_W):
		if !get_owner().landing:
			get_owner().transition_rotate(-TURN_SPEED,Vector3(1, 0, 0))
		else:
			get_owner().transition_rotate(-(delta * (SHIP_TURN_RATE * 10)),Vector3(1, 0, 0))
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
			get_owner().transition_rotate(TURN_SPEED,Vector3(0, 0, 1))
		else:
			get_owner().transition_rotate(delta * (SHIP_TURN_RATE * 10),Vector3(0, 0, 1))
			
	if Input.is_key_pressed(KEY_E):
		if !get_owner().landing:
			get_owner().transition_rotate(-TURN_SPEED,Vector3(0, 0, 1))
		else:
			get_owner().transition_rotate(-(delta * (SHIP_TURN_RATE * 10)),Vector3(0, 0, 1))
