extends Node2D

export (String) var item_name
export (String, MULTILINE) var item_tooltip
export (int) var item_cost
export (Color) var flour_modulate = Color(1, 1, 1, 1)

onready var label = $Label
onready var tooltip_question_mark = $Panel
onready var flour = $Flour
onready var buy_button = $Button


# Called when the node enters the scene tree for the first time.
func _ready():
	flour.modulate = flour_modulate
	label.text = "%s: %d" % [item_name, item_cost]
	tooltip_question_mark.hint_tooltip = item_tooltip
	var _err = buy_button.connect("pressed", self, "_on_buy_button_pressed")


func _on_buy_button_pressed() -> void:
	flour.buy()
