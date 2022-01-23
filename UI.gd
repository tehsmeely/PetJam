extends CanvasLayer

signal sleep_button_pressed
signal quit_to_menu

onready var gold_label = $Control/MarginContainer/HBoxContainer/GoldCounter/NinePatchRect/Label
onready var day_label = $Control/MarginContainer/HBoxContainer/DayCounter/Label

onready var left_arrow = $MarginContainer/HBoxContainer/LeftArrow
onready var right_arrow = $MarginContainer/HBoxContainer/RightArrow

onready var sleep_button = $Control/MarginContainer/HBoxContainer/SleepButton
onready var mini_menu = $MiniMenu/Popup
onready var help_dialog = $HelpPopup/AcceptDialog
onready var mm_continue_button = $MiniMenu/Popup/VBoxContainer/ContinueButton
onready var mm_quit_button = $MiniMenu/Popup/VBoxContainer/QuitButton

onready var cog_button = $Control/MarginContainer/HBoxContainer/CogButton
onready var help_button = $Control/MarginContainer/HBoxContainer/QuestionMarkButton


# Called when the node enters the scene tree for the first time.
func _ready():
	var err = GameState.connect("gold_changed", self, "_on_gold_changed")
	Global.handle_connect_error(err)
	var err2 = GameState.connect("day_changed", self, "_on_day_changed")
	Global.handle_connect_error(err2)
	var err3 = sleep_button.connect("pressed", self, "_on_sleep_button_pressed")
	Global.handle_connect_error(err3)

	var err4 = mm_continue_button.connect("pressed", self, "close_mini_menu")
	Global.handle_connect_error(err4)
	var err5 = mm_quit_button.connect("pressed", self, "_on_mm_quit_button")
	Global.handle_connect_error(err5)

	var err6 = cog_button.connect("pressed", self, "open_mini_menu")
	Global.handle_connect_error(err6)
	var err7 = help_button.connect("pressed", self, "open_help_dialog")
	Global.handle_connect_error(err7)

	help_dialog.get_close_button().visible = false


func _on_mm_quit_button() -> void:
	emit_signal("quit_to_menu")


func open_mini_menu() -> void:
	mini_menu.popup()


func open_help_dialog() -> void:
	help_dialog.popup()


func close_mini_menu() -> void:
	mini_menu.visible = false


func set_arrow_visibility(left: bool, right: bool) -> void:
	left_arrow.visible = left
	right_arrow.visible = right


func _on_gold_changed(new_gold: float) -> void:
	gold_label.text = "%.2d" % [new_gold]


func _on_day_changed(new_day: int) -> void:
	day_label.text = "Day %d" % [new_day]


func _on_sleep_button_pressed() -> void:
	emit_signal("sleep_button_pressed")
