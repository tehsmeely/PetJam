extends CanvasLayer

onready var gold_label = $Control/MarginContainer/HBoxContainer/GoldCounter/NinePatchRect/Label
onready var day_label = $Control/MarginContainer/HBoxContainer/DayCounter/Label

onready var left_arrow = $MarginContainer/HBoxContainer/LeftArrow
onready var right_arrow = $MarginContainer/HBoxContainer/RightArrow


# Called when the node enters the scene tree for the first time.
func _ready():
	var err = GameState.connect("gold_changed", self, "_on_gold_changed")
	Global.handle_connect_error(err)
	var err2 = GameState.connect("day_changed", self, "_on_day_changed")
	Global.handle_connect_error(err2)


func set_arrow_visibility(left: bool, right: bool) -> void:
	left_arrow.visible = left
	right_arrow.visible = right


func _on_gold_changed(new_gold: float) -> void:
	gold_label.text = "%.2d" % [new_gold]


func _on_day_changed(new_day: int) -> void:
	day_label.text = "Day %d" % [new_day]
