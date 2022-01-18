extends Node

signal gold_changed(new_gold)
signal day_changed(new_day)

var gold := 0.0 setget _set_gold
var day := 0 setget _set_day


func load() -> void:
	self.gold = 100.0
	self.day = 0


func _set_gold(new_gold: float) -> void:
	gold = new_gold
	emit_signal("gold_changed", new_gold)


func _set_day(new_day: int) -> void:
	day = new_day
	emit_signal("day_changed", new_day)
