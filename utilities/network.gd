extends Spatial

var player = preload("res://scenes/player/player.tscn")
var bullet = preload("res://scenes/bullet/bullet.tscn")
var peer;

# Player info, associate ID to data
var client_info = {}
# Info we send to other players
var my_info = { id = store.settings.get_value("info","id",uuid.generate()) }
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
#	var instance_my_player = player.instance()
#	instance_my_player.set_name("player_"+my_info.id)
#	instance_my_player.set_network_master(get_tree().get_network_unique_id())
#	instance_my_player.owner_name = my_info.id
#	$"/root/igfs/children/world/objects".add_child(instance_my_player)

	register_client(get_tree().get_network_unique_id(),my_info)
	var ship_info = {
		id=my_info.id,
		owner_name=my_info.id,
		type="player"
	}
	register_object(get_tree().get_network_unique_id(),ship_info)
#	
#	print(OS.get_unique_id())
#	yield(get_tree().create_timer(30), "timeout")	
#	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!save")
#	save()
	yield(get_tree().create_timer(15), "timeout")	
	load_game()
	
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
	var ship_info = {
		id=my_info.id,
		owner_name=my_info.id,
		type="player"
	}
	rpc("register_object",  get_tree().get_network_unique_id(), ship_info)
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
#		rpc_id(id, "register_client", 1, my_info)
#		rpc_id(id, "register_object",  1, "player", my_info)
		# Send the info of existing players
		for peer_id in client_info:
			if peer_id != id:
				rpc_id(id, "register_client", peer_id, client_info[peer_id])
				var ship_info = objects[client_info[peer_id].id]
				rpc_id(id, "register_object",  peer_id, ship_info)
	
remote func register_object(owner,info):
	
	print("--------------")
	print("Registering object, owner: " + str(owner))
	print("Object info:")
	print(info)
	print("--------------")
	var id;
	
	if info.type == "player":
		id = str(info.id)
		# Load new player
		var instance_player = player.instance()
		instance_player.set_name(id)
		instance_player.owner_name = info.id
		instance_player.set_network_master(owner) # Will be explained later
		$"/root/igfs/children/world/objects".add_child(instance_player)
	elif info.type == "bullet":
		id = str(info.id)
		print("bullet id: "+str(id))
		var instance_bullet = bullet.instance()
		instance_bullet.set_name(id)
		instance_bullet.owner_name = info.owner_name
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


func save():
	var state = {}
	var objects_save = {}
#	var id = "player_"+my_info.id
#	var my_object = my_info.duplicate()
#	var my_node = get_node("/root/igfs/children/world/objects/"+id)
#	var my_trans = my_node.get_global_transform()
#	my_object.transform = my_trans
#	objects_save[id] = my_object
	var ids = objects.keys()
	for id in ids:
		var object = objects[id].duplicate()
		var node = get_node("/root/igfs/children/world/objects/"+id)
		var trans = var2str(node.get_global_transform())
#		
#
#
#
#
#
#
#
#
#
#			STORE HEALTH
#
#
#
#
#
#
#
#
#
#
#

#		print(trans[0])
		object.transform = trans
		objects_save[id] = object
#	print(JSON.print(objects_save,"  "))
	state.objects = objects_save
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://save_game.dat", File.WRITE, OS.get_unique_id())
	f.store_string(JSON.print(state))
	f.close()
	
#	f = File.new()
#	f.open_encrypted_with_pass("res://save_game.dat", File.READ, OS.get_unique_id())
#	print(f.get_as_text())
#	f.close()
	

func load_game():
	var f = File.new()
	f.open_encrypted_with_pass("res://save_game.dat", File.READ, OS.get_unique_id())
	var content = JSON.parse(f.get_as_text()).result
#	print(content)
	f.close()
	var objects = content.objects
	var ids = objects.keys()
	for id in ids:
		var object = objects[id].duplicate()
#		var network_master = client_info[object.owner_name]
		var network_master;
		var network_ids = client_info.keys()
		for network_id in network_ids:
			var info = client_info[network_id]
			var client_id = info.id
			if client_id == object.owner_name:
				network_master = network_id
#			register_object(network_master,)
		if network_master:
#			print(network_master)
#			if network_master == get_tree().get_network_unique_id():
			if !has_node("/root/igfs/children/world/objects/"+id):
				register_object(network_master,object)
				var node = get_node("/root/igfs/children/world/objects/"+id)
				node.set_global_transform(str2var(object.transform))
				rpc("register_object",  network_master, object)
			else:
				var node = get_node("/root/igfs/children/world/objects/"+id)
				node.set_global_transform(str2var(object.transform))
#			else:
#				pass
