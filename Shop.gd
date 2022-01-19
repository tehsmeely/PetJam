extends Node2D

onready var shelves = $Shelves

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
	emit_signal("item_purchased", name)
