extends Node2D

export (NodePath) var pet_view
export (NodePath) var inventory_view

onready var camera = $Camera
onready var pet = $PetView/Pet
onready var slider = $CanvasLayer/Control/MarginContainer/VBoxContainer/VSlider
onready var feed_button = $CanvasLayer/Control/MarginContainer/VBoxContainer/FeedButton
onready var bake_button = $CanvasLayer/Control/MarginContainer/VBoxContainer/BakeButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active_view_position = 0 setget _set_active_view_position

onready var view_positions = [get_node(pet_view), get_node(inventory_view)]


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err1 = slider.connect("value_changed", self, "_on_slider_value_changed")
	_on_slider_value_changed(slider.value)

	var _err2 = feed_button.connect("pressed", pet, "feed")
	var _err3 = bake_button.connect("pressed", self, "_on_bake_button_pressed")

	camera.smoothing_enabled = false
	self._actually_set_active_view_position(0, true)
	camera.smoothing_enabled = true


func _process(_delta):
	if Input.is_action_pressed("ui_right"):
		self.active_view_position = clamp(active_view_position + 1, 0, 1)
	elif Input.is_action_pressed("ui_left"):
		self.active_view_position = clamp(active_view_position - 1, 0, 1)


func _on_slider_value_changed(new_val: float) -> void:
	print("Fill Pct: ", new_val)
	pet.set_fill_level_pct(new_val)


func _on_bake_button_pressed():
	if pet.fill_level_pct > 20.0:
		pet.fill_level_pct -= 20.0


func _set_active_view_position(new_avp: int) -> void:
	if new_avp != active_view_position:
		active_view_position = new_avp
		_actually_set_active_view_position(new_avp, false)


func _actually_set_active_view_position(avp: int, set_y: bool) -> void:
	var target_node = self.view_positions[avp].get_node("CameraPos")
	camera.global_position.x = target_node.global_position.x
	if set_y:
		camera.global_position.y = target_node.global_position.y
