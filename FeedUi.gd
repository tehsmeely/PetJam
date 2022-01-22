extends Control

signal flour_fed(flour_name)

var item_names
var item_colours
var item_quantities
var current_item_index := 0 setget _set_current_item_index

onready var l_button = $VBoxContainer/HBoxContainer/LButton
onready var r_button = $VBoxContainer/HBoxContainer/RButton
onready var name_label = $VBoxContainer/NameLabel
onready var qty_label = $VBoxContainer/QtyLabel
onready var item_texture = $VBoxContainer/HBoxContainer/TextureRect
onready var item_texture_animation_player = $VBoxContainer/HBoxContainer/TextureRect/AnimationPlayer
onready var item_texture_transition_timer = $VBoxContainer/HBoxContainer/TextureRect/TransitionTimer
onready var feed_button = $VBoxContainer/FeedButton


# Called when the node enters the scene tree for the first time.
func _ready():
	item_names = HealthEffect.all_flours()
	item_colours = []
	item_quantities = {}
	for item in item_names:
		item_colours.append(HealthEffect.colour_of_flour(item))
		item_quantities[item] = 0
	var err = l_button.connect("pressed", self, "_on_left_pressed")
	Global.handle_connect_error(err)
	var err2 = r_button.connect("pressed", self, "_on_right_pressed")
	Global.handle_connect_error(err2)
	var err3 = item_texture_transition_timer.connect("timeout", self, "_on_transition_timer_fired")
	Global.handle_connect_error(err3)
	var err4 = feed_button.connect("pressed", self, "_on_feed_button_pressed")
	Global.handle_connect_error(err4)

	_apply_current_item_index()


func add_quantity(item_name: String) -> void:
	item_quantities[item_name] = item_quantities.get(item_name, 0) + 1
	_apply_current_item_index()


func _on_feed_button_pressed() -> void:
	var item_name = item_names[current_item_index]
	if not item_texture_animation_player.is_playing() and item_quantities[item_name] > 0:
		item_texture_animation_player.play("Feed")
		emit_signal("flour_fed", item_name)


func _on_right_pressed() -> void:
	self.current_item_index += 1
	item_texture_animation_player.play("MoveRight")


func _on_left_pressed() -> void:
	self.current_item_index -= 1
	item_texture_animation_player.play("MoveLeft")


func _set_current_item_index(new_index: int) -> void:
	current_item_index = new_index
	if current_item_index < 0:
		current_item_index = len(item_names) + current_item_index
	elif current_item_index >= len(item_names):
		current_item_index = current_item_index - len(item_names)

	item_texture_transition_timer.start()


func _on_transition_timer_fired() -> void:
	_apply_current_item_index()


func _apply_current_item_index() -> void:
	name_label.text = item_names[current_item_index]
	qty_label.text = str(item_quantities[item_names[current_item_index]])
	item_texture.self_modulate = item_colours[current_item_index]
