extends Node2D

export (NodePath) var pet_node
export (NodePath) var inventory_node
export (NodePath) var shop_node
export (float) var overflow_cleanup_cost = 25.0
export (String, FILE, "*.tscn,*.scn") var main_menu_scene = null

onready var camera = $Camera
onready var pet = get_node(pet_node)
onready var inventory = get_node(inventory_node)
onready var shop = get_node(shop_node)
onready var popup = $UI/PopupContainer/AcceptDialog
onready var slider = $DebugUI/Control/MarginContainer/VBoxContainer/VSlider
onready var feed_button = $DebugUI/Control/MarginContainer/VBoxContainer/FeedButton
onready var bake_button = $DebugUI/Control/MarginContainer/VBoxContainer/BakeButton
onready var sleep_button = $DebugUI/Control/MarginContainer/VBoxContainer/SleepButton
onready var show_health_button = $DebugUI/Control/MarginContainer/VBoxContainer/HealthButton
onready var night_transition_animation = $NightTransition/ColorRect/AnimationPlayer
onready var popup_overflow = $UI/OverflowPopup/AcceptDialog
onready var popup_emptyloss = $UI/EmptyLossPopup/AcceptDialog
onready var audio_overflow = $Audio/Overflow
onready var audio_emptyloss = $Audio/EmptyLoss
onready var audio_night = $Audio/Night
onready var ui = $UI

var active_view_position = 0 setget _set_active_view_position

onready var view_positions = [pet, inventory, shop]


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err1 = slider.connect("value_changed", self, "_on_slider_value_changed")
	_on_slider_value_changed(slider.value)

	var _err2 = feed_button.connect("pressed", pet, "debug_feed")
	var _err3 = bake_button.connect("pressed", self, "_on_bake_button_pressed")
	var err4 = sleep_button.connect("pressed", self, "end_of_day")
	Global.handle_connect_error(err4)
	var err5 = show_health_button.connect("pressed", self, "_on_show_health_button")
	Global.handle_connect_error(err5)

	camera.smoothing_enabled = false
	self._actually_set_active_view_position(0, true)
	camera.smoothing_enabled = true

	var err6 = get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
	Global.handle_connect_error(err6)
	self._on_viewport_size_changed()

	var err7 = shop.connect("item_purchased", self, "_on_item_purchased")
	Global.handle_connect_error(err7)

	var err8 = pet.connect("overflow_occured", self, "_on_pet_overflow")
	Global.handle_connect_error(err8)
	var err9 = pet.connect("empty_occured", self, "_on_pet_empty")
	Global.handle_connect_error(err9)
	var err10 = pet.connect("bread_baked", self, "_on_bread_baked")
	Global.handle_connect_error(err10)

	var err11 = ui.connect("sleep_button_pressed", self, "end_of_day")
	Global.handle_connect_error(err11)

	pet.set_name(GameState.starter_name)

	print("Main Ready")
	GameState.reload()
	MusicPlayer.set_mode(MusicPlayer.MusicMode.GAME)
	_setup_popups()


func _setup_popups() -> void:
	popup_emptyloss.get_close_button().visible = false
	popup_emptyloss.connect("confirmed", self, "_end_game")
	popup_overflow.get_close_button().visible = false
	popup_overflow.connect("confirmed", self, "_on_overflow_confirmed")


func _end_game():
	SaveLoad.clear_save()
	SceneSwitcher.goto_scene(main_menu_scene)


func _on_item_purchased(item_name: String) -> void:
	pet.add_flour(item_name)


func _on_show_health_button() -> void:
	popup.dialog_text = pet.health.debug_string()
	popup.popup()


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


func _on_pet_overflow() -> void:
	popup_overflow.popup()
	audio_overflow.play()


func _on_overflow_confirmed() -> void:
	if GameState.gold < self.overflow_cleanup_cost:
		GameState.gold = 0
	else:
		GameState.gold -= self.overflow_cleanup_cost

	pet.penalise_health()


func _on_pet_empty() -> void:
	popup_emptyloss.popup()
	audio_emptyloss.play()


func _on_bake_button_pressed():
	pet.debug_bake()


func _on_bread_baked(quality: int) -> void:
	inventory.add_bread(quality)


func end_of_day() -> void:
	audio_night.play()
	night_transition_animation.play("FadeOutFadeIn")
	GameState.day += 1

	#Update Pet Health / Volume
	pet.end_of_day()

	#Update Market Prices
	inventory.end_of_day()

	#Restock Shop
	shop.end_of_day()

	SaveLoad.save_all()


func _set_active_view_position(new_avp: int) -> void:
	if new_avp != active_view_position:
		active_view_position = new_avp
		_actually_set_active_view_position(new_avp, false)


func _actually_set_active_view_position(avp: int, set_y: bool) -> void:
	ui.set_arrow_visibility(avp > 0, avp < 2)
	var target_node = self.view_positions[avp].get_node("CameraPos")
	camera.global_position.x = target_node.global_position.x
	if set_y:
		camera.global_position.y = target_node.global_position.y


var save_name = "GameMain"


func save() -> Dictionary:
	return {"game_state": GameState.save()}


func load(data: Dictionary) -> void:
	GameState.load(data["game_state"])
