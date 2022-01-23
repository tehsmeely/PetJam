extends Node2D

onready var shelves = $Shelves
onready var sfx_player = $AudioStreamPlayer

signal item_purchased(name)


func _ready():
	for shelf in shelves.get_children():
		shelf.connect("purchased", self, "_on_shelf_purchased")


func end_of_day() -> void:
	print("Shop End of day")
	for shelf in shelves.get_children():
		shelf.randomise_cost()
		shelf.recover_stock()


func camera_pos_x_offset() -> float:
	return get_node("CameraPos").position.x


func _on_shelf_purchased(name: String) -> void:
	print("item_purchased", name)
	sfx_player.play()
	emit_signal("item_purchased", name)


var save_name = "GameShop"


func save() -> Dictionary:
	var data = {}
	for shelf in shelves.get_children():
		data[shelf.item_name] = shelf.save()
	return data


func load(data: Dictionary) -> void:
	for shelf in shelves.get_children():
		shelf.load(data[shelf.item_name])
