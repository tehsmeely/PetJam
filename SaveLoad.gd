extends Node

var save_filename := "user://savegame.dat"


func save_all() -> void:
	var save_nodes = get_tree().get_nodes_in_group("SaveLoad")
	var data = {}
	for node in save_nodes:
		assert(
			node.has_method("save") and ("save_name" in node),
			"Node in SaveLoad group must have save function and save_name attribute"
		)
		var node_data = node.call("save")
		print("Saving node ", node.save_name)
		data[node.save_name] = node_data
	var save_game = File.new()
	save_game.open(save_filename, File.WRITE)
	save_game.store_string(to_json(data))
	save_game.close()


func save_file_available() -> bool:
	var save_game = File.new()
	return save_game.file_exists(save_filename)


func load_all() -> void:
	## Assumes save file exists
	var save_game = File.new()
	save_game.open(save_filename, File.READ)
	var data = parse_json(save_game.get_as_text())
	save_game.close()
	var load_nodes = get_tree().get_nodes_in_group("SaveLoad")
	for node in load_nodes:
		assert(
			node.has_method("load") and ("save_name" in node),
			"Node in SaveLoad group must have load function and save_name attribute"
		)
		print("Loading node ", node.save_name)
		var node_data = data.get(node.save_name)
		assert(node_data != null, "Expecting load data for all nodes in SaveLoad from savefile")
		if node_data != null:
			node.call("load", node_data)
