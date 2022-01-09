extends Node2D

onready var pet = $Pet
onready var slider = $CanvasLayer/Control/MarginContainer/VBoxContainer/VSlider
onready var feed_button = $CanvasLayer/Control/MarginContainer/VBoxContainer/FeedButton
onready var bake_button = $CanvasLayer/Control/MarginContainer/VBoxContainer/BakeButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err1 = slider.connect("value_changed", self, "_on_slider_value_changed")
	_on_slider_value_changed(slider.value)

	var _err2 = feed_button.connect("pressed", pet, "feed")
	var _err3 = bake_button.connect("pressed", self, "_on_bake_button_pressed")
	pass


func _on_slider_value_changed(new_val: float) -> void:
	print("Fill Pct: ", new_val)
	pet.set_fill_level_pct(new_val)


func _on_bake_button_pressed():
	if pet.fill_level_pct > 20.0:
		pet.fill_level_pct -= 20.0
