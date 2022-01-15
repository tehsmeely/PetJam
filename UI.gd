extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var gold_label = $Control/MarginContainer/HBoxContainer/GoldCounter/NinePatchRect/MarginContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = GameState.connect("gold_changed", self, "_on_gold_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_gold_changed(new_gold: float) -> void:
	gold_label.text = "%.2d" % [new_gold]
