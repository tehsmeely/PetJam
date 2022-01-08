extends Node2D

onready var pet = $Pet
onready var slider = $CanvasLayer/Control/MarginContainer/VSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	slider.connect("value_changed", self, "_on_slider_value_changed")
	_on_slider_value_changed(slider.value)
	pass 


func _on_slider_value_changed(new_val: float) -> void:
	print("Fill Pct: ", new_val)
	pet.set_fill_level_pct(new_val)

