extends Node

signal gold_changed(new_gold)
signal day_changed(new_day)

var gold := 30.0 setget _set_gold
var day := 1 setget _set_day

var starter_name = ""


func reload() -> void:
	self.gold = self.gold
	self.day = self.day


func _set_gold(new_gold: float) -> void:
	gold = new_gold
	emit_signal("gold_changed", new_gold)


func _set_day(new_day: int) -> void:
	day = new_day
	emit_signal("day_changed", new_day)


func save() -> Dictionary:
	# This also needs to include the shop state, inventory state, and pet(-health) state
	return {"starter_name": starter_name, "gold": gold, "day": day}


func load(data: Dictionary) -> void:
	self.gold = data["gold"]
	self.day = data["day"]
	self.starter_name = data["starter_name"]
