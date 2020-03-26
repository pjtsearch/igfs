extends Spatial

var player = preload("res://scenes/player/player.tscn")
var bullet = preload("res://scenes/bullet/bullet.tscn")
var peer;

# Player info, associate ID to data
var client_info = {}
# Info we send to other players
var my_info = { id = store.settings.get_value("info","id",str(randi()%100000000001+1)) }
var objects = {}
# Called when the node enters the scene tree for the first time.
func start():
	var server = store.settings.get_value("multiplayer", "server", false)
	#var instance_player = player.instance()
	#add_child(instance_player)
	print("server:" + str(server))
	if server:
		peer = NetworkedMultiplayerENet.new()
		peer.create_server(8000, 5)
		get_tree().set_network_peer(peer)
	else:
		peer = NetworkedMultiplayerENet.new()
		peer.create_client("10.0.2.105", 8000)
		get_tree().set_network_peer(peer)

	var i_self = self
	get_tree().connect("network_peer_connected", self,"_client_connected")
	get_tree().connect("network_peer_disconnected", self,"_client_disconnected")
	get_tree().connect("connected_to_server",  self,"_connected_ok")
	get_tree().connect("connection_failed",  self,"_connected_fail")
	get_tree().connect("server_disconnected",  self,"_server_disconnected")
	
	#register_client(get_tree().get_network_unique_id(),my_info)
	var instance_my_player = player.instance()
	instance_my_player.set_name("player_"+my_info.id)
	instance_my_player.set_network_master(get_tree().get_network_unique_id())
	$"/root/igfs/children/world/objects".add_child(instance_my_player)

func stop():
	print("stopping server")
	peer.close_connection()


func _client_connected(id):
	pass
	# Called on both clients and server when a peer connects. Send my info to it.
#	rpc_id(id, "register_client", my_info)
#	print_debug("after rpc register_client: " + str(id))

func _client_disconnected(id):
	client_info.erase(id) # Erase player from info.

func _connected_ok():
	print_debug("_connected_ok: " + str(get_tree().get_network_unique_id()))
	
	yield(get_tree().create_timer(2), "timeout")
	rpc("register_client", get_tree().get_network_unique_id(), my_info)
	rpc("register_object",  get_tree().get_network_unique_id(), "player", my_info)
	# Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	print_debug("_server_disconnected")
	SceneLoader.goto_scene("res://scenes/main_menu/main_menu.tscn")

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_client(id, info):
	print("--------------")
	print("Registering client, id: " + str(id))
	print("Client info:")
	print(info)
	print("--------------")
	
	client_info[id] = info
	
	# If I'm the server, let the new guy know about existing players.
	if get_tree().is_network_server() && id != 1:
		#my_info.ship = ShipInfo.ship
		# Send my info to new player
		rpc_id(id, "register_client", 1, my_info)
		rpc_id(id, "register_object",  1, "player", my_info)
		# Send the info of existing players
		for peer_id in client_info:
			if peer_id != id:
				rpc_id(id, "register_client", peer_id, client_info[peer_id])
				rpc_id(id, "register_object",  peer_id, "player", client_info[peer_id])
	
remote func register_object(owner,type,info):
	
	print("--------------")
	print("Registering object, owner: " + str(owner))
	print("Object info:")
	print(info)
	print("--------------")
	var id;
	
	if type == "player":
		id = "player_"+str(info.id)
		# Load new player
		var instance_player = player.instance()
		instance_player.set_name(id)
		instance_player.set_network_master(owner) # Will be explained later
		$"/root/igfs/children/world/objects".add_child(instance_player)
	elif type == "bullet":
		id = info.id
		print("bullet id: "+str(id))
		var instance_bullet = bullet.instance()
		instance_bullet.set_name(id)
		instance_bullet.set_network_master(owner)
		#print("register_object add_child")
		$"/root/igfs/children/world/objects".add_child(instance_bullet)
	
	objects[id] = info

	print("Objects: " + str(objects))

remote func unregister_object(id):
	print("--------------")
	print("Unregistering object, id: " + str(id))
	print("--------------")
	
	if has_node("/root/igfs/children/world/objects/"+id):
		get_node("/root/igfs/children/world/objects/"+id).queue_free()
	objects.erase(id)
	
	print("Objects: " + str(objects))
