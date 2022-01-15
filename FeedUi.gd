extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (Array, String) var item_names
export (Array, Color) var item_colours

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
	assert(
		len(item_names) == len(item_colours),
		"numbers of item names and item colours should match up"
	)

	var _err = l_button.connect("pressed", self, "_on_left_pressed")
	var _err2 = r_button.connect("pressed", self, "_on_right_pressed")
	var _err3 = item_texture_transition_timer.connect("timeout", self, "_on_transition_timer_fired")
	var _err4 = feed_button.connect("pressed", self, "_on_feed_button_pressed")

	_apply_current_item_index()


func _on_feed_button_pressed() -> void:
	if not item_texture_animation_player.is_playing():
		item_texture_animation_player.play("Feed")


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
	qty_label = current_item_index
	item_texture.self_modulate = item_colours[current_item_index]
