extends Node

signal gold_changed(new_gold)

var gold := 0.0 setget _set_gold


func _set_gold(new_gold: float) -> void:
	gold = new_gold
	emit_signal("gold_changed", new_gold)
