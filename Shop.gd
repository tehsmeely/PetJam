extends Node2D

onready var shelves = $Shelves

signal item_purchased(name)


# Called when the node enters the scene tree for the first time.
func _ready():
	for shelf in shelves.get_children():
		shelf.connect("purchased", self, "_on_shelf_purchased")


func _on_shelf_purchased(name: String) -> void:
	emit_signal("item_purchased", name)
