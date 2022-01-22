extends Control

onready var new_game_button = $CenterContainer/VBoxContainer/NewGameButton
onready var continue_button = $CenterContainer/VBoxContainer/ContinueButton
onready var quit_button = $CenterContainer/VBoxContainer/QuitButton

export (String, FILE, "*.tscn,*.scn") var new_game_scene
export (String, FILE, "*.tscn,*.scn") var game_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_available = SaveLoad.save_file_available()
	continue_button.disabled = not save_available

	var err1 = new_game_button.connect("pressed", self, "_on_new_game_button")
	Global.handle_connect_error(err1)
	var err2 = continue_button.connect("pressed", self, "_on_continue_button")
	Global.handle_connect_error(err2)
	var err3 = quit_button.connect("pressed", self, "_on_quit_button")
	Global.handle_connect_error(err3)


func _on_new_game_button() -> void:
	SceneSwitcher.goto_scene(new_game_scene)


func _on_continue_button() -> void:
	SceneSwitcher.goto_scene_and_load(game_scene)


func _on_quit_button() -> void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
