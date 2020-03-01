extends Spatial

var player = preload("res://scenes/player/player.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func start():
	var server = settings.get_value("multiplayer", "server", false)
	#var instance_player = player.instance()
	#add_child(instance_player)
	print("server:" + str(server))
	if server:
		var peer = NetworkedMultiplayerENet.new()
		peer.create_server(8000, 5)
		get_tree().set_network_peer(peer)
	else:
		var peer = NetworkedMultiplayerENet.new()
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
	instance_my_player.set_name("player_"+str(get_tree().get_network_unique_id()))
	instance_my_player.set_network_master(get_tree().get_network_unique_id())
	$"/root/igfs/children/world/players".add_child(instance_my_player)

# Player info, associate ID to data
var client_info = {}
# Info we send to other players
var my_info = { name = "PJT" }
var objects = {}

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
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

#remote func register_client(info):
#	# Get the id of the RPC sender.
#	var id = get_tree().get_rpc_sender_id()
#	# Store the info
#	client_info[id] = info
	
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
	var id = type+"_"+str(owner)
	print("--------------")
	print("Registering object, id: " + str(id))
	print("Object info:")
	print(info)
	print("--------------")
	
	objects[id] = info
	
	if type == "player":
		# Load new player
		var instance_player = player.instance()
		instance_player.set_name(str(id))
		instance_player.set_network_master(owner) # Will be explained later
		$"/root/igfs/children/world/players".add_child(instance_player)

	print("Objects: " + str(objects))
	
#remote func pre_configure_game():
#	var selfPeerID = get_tree().get_network_unique_id()
#
#	# Load my player
#	var instance_my_player = player.instance()
#	instance_my_player.set_name(str(selfPeerID))
#	instance_my_player.set_network_master(selfPeerID) # Will be explained later
#	add_child(instance_my_player)
#
#	# Load other players
#	for client in client_info:
#		var instance_player = player.instance()
#		instance_player.set_name(str(client))
#		instance_player.set_network_master(client) # Will be explained later
#		add_child(instance_player)
#
#	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
#	rpc_id(1, "done_preconfiguring", selfPeerID)

#unneccesary
#var clients_done = []
#remote func done_preconfiguring(who):
#	# Here are some checks you can do, for example
#	assert(get_tree().is_network_server())
#	assert(who in client_info) # Exists
#	assert(not who in clients_done) # Was not added yet
#
#	clients_done.append(who)
#
#	if clients_done.size() == client_info.size():
#		rpc("post_configure_game")
#
#remote func post_configure_game():
#	# Game starts now!
#	pass
