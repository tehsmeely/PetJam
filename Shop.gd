extends Node2D

onready var shelves = $Shelves
onready var one_off_shelves = $OneOffShelves
onready var sfx_player = $AudioStreamPlayer
onready var info_popup = $CanvasLayer/CenterContainer/AcceptDialog

signal item_purchased(name)
signal one_off_item_purchased(name)


func _ready():
	for shelf in shelves.get_children():
		shelf.connect("purchased", self, "_on_shelf_purchased")
		shelf.connect("info_popup", self, "_on_shelf_window_popup")

	for shelf in one_off_shelves.get_children():
		shelf.connect("purchased", self, "_on_one_off_shelf_purchased")
		shelf.connect("info_popup", self, "_do_info_popup")

	info_popup.get_close_button().visible = false


func end_of_day() -> void:
	print("Shop End of day")
	for shelf in shelves.get_children():
		shelf.randomise_cost()
		shelf.recover_stock()


func camera_pos_x_offset() -> float:
	return get_node("CameraPos").position.x


func _on_shelf_window_popup(name: String) -> void:
	print("info popup")
	var info = HealthEffect.description_of_name(name)
	_do_info_popup(name, info)


func _do_info_popup(title: String, text: String) -> void:
	info_popup.dialog_text = text
	info_popup.window_title = title
	info_popup.popup()


func _on_shelf_purchased(name: String) -> void:
	print("item_purchased", name)
	sfx_player.play()
	emit_signal("item_purchased", name)


func _on_one_off_shelf_purchased(name: String) -> void:
	print("one_off_item_purchased", name)
	sfx_player.play()
	emit_signal("one_off_item_purchased", name)


var save_name = "GameShop"


func save() -> Dictionary:
	var shelf_data = {}
	for shelf in shelves.get_children():
		shelf_data[shelf.item_name] = shelf.save()

	var oo_shelf_data = {}
	for shelf in one_off_shelves.get_children():
		oo_shelf_data[shelf.item_name] = shelf.save()

	return {"shelves": shelf_data, "one_off_shelves": oo_shelf_data}


func load(data: Dictionary) -> void:
	for shelf in shelves.get_children():
		shelf.load(data["shelves"][shelf.item_name])

	for shelf in one_off_shelves.get_children():
		shelf.load(data["one_off_shelves"][shelf.item_name])
