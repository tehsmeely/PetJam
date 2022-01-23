extends Node2D

onready var shelves = $Shelves
onready var sfx_player = $AudioStreamPlayer
onready var info_popup = $CanvasLayer/CenterContainer/AcceptDialog

signal item_purchased(name)


func _ready():
	for shelf in shelves.get_children():
		shelf.connect("purchased", self, "_on_shelf_purchased")
		shelf.connect("info_popup", self, "_on_shelf_window_popup")

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
	info_popup.dialog_text = info
	info_popup.window_title = name
	info_popup.popup()


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
