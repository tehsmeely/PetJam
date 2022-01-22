extends Node2D

signal purchased(name)

export (String) var item_name
export (String, MULTILINE) var item_tooltip
export (float) var item_cost_min
export (float) var item_cost_max
export (int) var stock_max
export (Color) var flour_modulate = Color(1, 1, 1, 1)

onready var label = $Label
onready var tooltip_question_mark = $Panel
onready var flour = $Flour
onready var buy_button = $Button
onready var stock = stock_max setget _set_stock

var item_cost
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	randomise_cost()
	flour.modulate = flour_modulate
	tooltip_question_mark.hint_tooltip = item_tooltip
	var _err = buy_button.connect("pressed", self, "_on_buy_button_pressed")
	_update_label_text()


func _update_label_text() -> void:
	label.text = "%s (%d): %d" % [item_name, stock, item_cost]


func _on_buy_button_pressed() -> void:
	if GameState.gold >= item_cost and stock > 0:
		flour.buy()
		emit_signal("purchased", self.item_name)
		GameState.gold -= item_cost
		self.stock -= 1


func _set_stock(new_stock: int) -> void:
	stock = new_stock
	_update_label_text()


func randomise_cost() -> void:
	item_cost = rng.randf_range(item_cost_min, item_cost_max)


func recover_stock() -> void:
	var recoup = rng.randi_range(0, stock_max)
	self.stock = clamp(0, stock + recoup, stock_max)


func save() -> Dictionary:
	# Item name is used as a key in the Shop parent save/load so excluded here
	return {"item_cost": self.item_cost, "stock": self.stock}


func load(data: Dictionary) -> void:
	self.item_cost = data["item_cost"]
	self.stock = data["stock"]
