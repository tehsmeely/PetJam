extends Node2D

export (NodePath) var pet_node
export (NodePath) var inventory_node
export (NodePath) var shop_node

onready var camera = $Camera
onready var pet = get_node(pet_node)
onready var inventory = get_node(inventory_node)
onready var shop = get_node(shop_node)
onready var slider = $DebugUI/Control/MarginContainer/VBoxContainer/VSlider
onready var feed_button = $DebugUI/Control/MarginContainer/VBoxContainer/FeedButton
onready var bake_button = $DebugUI/Control/MarginContainer/VBoxContainer/BakeButton
onready var sleep_button = $DebugUI/Control/MarginContainer/VBoxContainer/SleepButton
onready var night_transition_animation = $NightTransition/ColorRect/AnimationPlayer

var active_view_position = 0 setget _set_active_view_position

onready var view_positions = [pet, inventory, shop]


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err1 = slider.connect("value_changed", self, "_on_slider_value_changed")
	_on_slider_value_changed(slider.value)

	var _err2 = feed_button.connect("pressed", pet, "feed")
	var _err3 = bake_button.connect("pressed", self, "_on_bake_button_pressed")
	var err4 = sleep_button.connect("pressed", self, "end_of_day")
	Global.handle_connect_error(err4)

	camera.smoothing_enabled = false
	self._actually_set_active_view_position(0, true)
	camera.smoothing_enabled = true

	var err5 = get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
	Global.handle_connect_error(err5)
	self._on_viewport_size_changed()

	print("Main Ready")
	GameState.load()


func _on_viewport_size_changed() -> void:
	# position_views
	# All the CameraPos node should be spaced Viewport.size.x apart
	var width = get_viewport().size.x
	var x0 = pet.global_position.x + pet.camera_pos_x_offset()
	var x1 = x0 + width - inventory.camera_pos_x_offset()
	var x2 = x0 + (2 * width) - shop.camera_pos_x_offset()

	inventory.global_position.x = x1
	shop.global_position.x = x2

	_actually_set_active_view_position(self.active_view_position, false)


func _process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		self.active_view_position = clamp(active_view_position + 1, 0, 2)
	elif Input.is_action_just_pressed("ui_left"):
		self.active_view_position = clamp(active_view_position - 1, 0, 2)


func _on_slider_value_changed(new_val: float) -> void:
	print("Fill Pct: ", new_val)
	pet.set_fill_level_pct(new_val)


func _on_bake_button_pressed():
	if pet.fill_level_pct > 20.0:
		bake_bread(pet.get_quality())


func bake_bread(quality: int) -> void:
	inventory.add_bread(quality)
	pet.fill_level_pct -= 20.0


func end_of_day() -> void:
	night_transition_animation.play("FadeOutFadeIn")
	GameState.day += 1

	#Update Pet Health / Volume
	pet.end_of_day()

	#Update Market Prices
	inventory.end_of_day()

	#Restock Shop
	shop.end_of_day()


func _set_active_view_position(new_avp: int) -> void:
	if new_avp != active_view_position:
		active_view_position = new_avp
		_actually_set_active_view_position(new_avp, false)


func _actually_set_active_view_position(avp: int, set_y: bool) -> void:
	var target_node = self.view_positions[avp].get_node("CameraPos")
	camera.global_position.x = target_node.global_position.x
	if set_y:
		camera.global_position.y = target_node.global_position.y
