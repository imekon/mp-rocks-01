extends Node2D

@onready var player = load("res://scenes/player.tscn")
@onready var rock1 = load("res://scenes/rock1.tscn")

var is_server: bool = true
var server_address: String = "localhost"
var server_port: int = 49641
var max_clients: int = 4
var _rock_id: int = 1
var _player_id: int = 1

@rpc()
func rock_status(_id, _x, _y):
	pass
	
@rpc()
func player_status(_id, _x, _y):
	pass

func _ready() -> void:
	randomize()
	if is_server:
		var peer = ENetMultiplayerPeer.new()
		peer.create_server(server_port, max_clients)
		peer.connect("peer_connected", _on_peer_connected)
		peer.connect("peer_disconnected", _on_peer_disconnected)
		multiplayer.multiplayer_peer = peer
	else:
		pass
		
	_generate_player(player, Utils.random_range(65536), Utils.random_range(65536))
	_generate_rocks(140, rock1)
	
func _process(_delta: float) -> void:
	var rocks = get_tree().get_nodes_in_group("rocks")
	for rock in rocks:
		rock_status.rpc(rock.id, rock.position.x, rock.position.y)
		
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player_status.rpc(player.id, player.position.x, player.position.y)

func _generate_player(play, x, y):
	var p = play.instantiate()
	p.position = Vector2(x, y)
	p.id = _player_id
	_player_id = _player_id + 1
	add_child(p)
	
func _generate_rocks(count, rock):
	for i in range(count):
		_generate_rock(rock, Utils.random_range(65536), Utils.random_range(65536))
		
func _generate_rock(rock, x, y):
	var p = rock.instantiate()
	p.position = Vector2(x, y)
	p.id = _rock_id
	_rock_id = _rock_id + 1
	add_child(p)

func _on_peer_connected(id):
	print("peer connected: ", id)
	
func _on_peer_disconnected(id):
	print("peer disconnected: ", id)
