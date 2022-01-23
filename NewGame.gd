extends Control

export (Array, String) var random_names = ["Sourdough"]

export (String, FILE, "*.tscn,*.scn") var game_scene = null

var rng = RandomNumberGenerator.new()

onready var text_box = $CenterContainer/VBoxContainer/HBoxContainer/LineEdit
onready var randomise_button = $CenterContainer/VBoxContainer/HBoxContainer/RandomButton
onready var play_button = $CenterContainer/VBoxContainer/Control/PlayButton
onready var back_button = $CenterContainer/VBoxContainer/Control2/BackButton


func _ready():
	rng.randomize()
	text_box.text = _pick_random_name()

	var err1 = randomise_button.connect("pressed", self, "_on_randomise_button")
	Global.handle_connect_error(err1)
	var err2 = play_button.connect("pressed", self, "_on_play_button")
	Global.handle_connect_error(err2)
	var err3 = back_button.connect("pressed", self, "_on_back_button")
	Global.handle_connect_error(err3)


func _on_randomise_button() -> void:
	text_box.text = _pick_random_name()


func _on_play_button() -> void:
	if text_box.text != "":
		GameState.starter_name = text_box.text
		SceneSwitcher.goto_scene(game_scene)


func _on_back_button() -> void:
	SceneSwitcher.pop()
	pass


func _pick_random_name() -> String:
	return random_names[rng.randi_range(0, random_names.size() - 1)]