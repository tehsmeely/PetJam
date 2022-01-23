extends Node2D

signal purchased(name)
signal info_popup(name, description)

export (String) var item_name
export (float) var item_cost
export (String, MULTILINE) var item_description
export (Texture) var item_texture
export (Color) var bought_modulate = Color(1, 1, 1, 0.5)

onready var label = $Label
onready var flour = $Flour
onready var buy_button = $Button
onready var help_dialog = $AcceptDialog
onready var help_button = $HelpButton
onready var item_sprite = $Sprite
onready var anim_player = $Sprite/AnimationPlayer

var bought = false setget _set_bought


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = buy_button.connect("pressed", self, "_on_buy_button_pressed")
	_update_label_text()

	var err2 = help_button.connect("pressed", self, "_on_help_button")
	Global.handle_connect_error(err2)

	item_sprite.texture = item_texture


func _set_bought(new_bought: bool) -> void:
	bought = new_bought

	buy_button.disabled = bought

	if bought:
		item_sprite.self_modulate = bought_modulate
	else:
		item_sprite.self_modulate = Color.white


func _on_help_button() -> void:
	emit_signal("info_popup", self.item_name, self.item_description)


func _update_label_text() -> void:
	label.text = "%s: %d" % [item_name, item_cost]


func _on_buy_button_pressed() -> void:
	if GameState.gold >= item_cost and not bought:
		emit_signal("purchased", self.item_name)
		GameState.gold -= item_cost
		anim_player.play("triple_wiggle")
		self.bought = true


func save() -> Dictionary:
	# Item name is used as a key in the Shop parent save/load so excluded here
	return {"bought": self.bought}


func load(data: Dictionary) -> void:
	self.bought = data["bought"]
