extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var gold_label = $Control/MarginContainer/HBoxContainer/GoldCounter/NinePatchRect/MarginContainer/Label
onready var day_label = $Control/MarginContainer/HBoxContainer/DayCounter/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var err = GameState.connect("gold_changed", self, "_on_gold_changed")
	Global.handle_connect_error(err)
	var err2 = GameState.connect("day_changed", self, "_on_day_changed")
	Global.handle_connect_error(err2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_gold_changed(new_gold: float) -> void:
	gold_label.text = "%.2d" % [new_gold]


func _on_day_changed(new_day: int) -> void:
	day_label.text = "Day %d" % [new_day]
