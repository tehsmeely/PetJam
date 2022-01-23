extends AudioStreamPlayer

export (Array, AudioStream) var menu_music
export (Array, AudioStream) var game_music

var enabled = true
var music_index = 0

enum MusicMode { OFF, MENU, GAME }

var current_mode = MusicMode.OFF


# Called when the node enters the scene tree for the first time.
func _ready():
	var e1 = self.connect("finished", self, "_on_track_finished")
	Global.handle_connect_error(e1)


func set_mode(mode: int) -> void:
	if mode != self.current_mode:
		self.current_mode = mode
		music_index = rand_range(0, _get_max_index_of_mode() - 1)
		self.stream = _get_stream_by_index(music_index)
		self.play()


func _on_track_finished() -> void:
	if self.current_mode != MusicMode.OFF:
		music_index += 1
		var max_i = _get_max_index_of_mode()
		if music_index >= max_i:
			music_index = 0

		self.stream = _get_stream_by_index(music_index)
		self.play()


func tick() -> void:
	print("Music Tick")


func _get_max_index_of_mode() -> int:
	match self.current_mode:
		MusicMode.MENU:
			return len(menu_music)
		MusicMode.GAME:
			return len(game_music)
		_:
			assert(false, "Unknown MusicMode")
			return 0


func _get_stream_by_index(index: int) -> AudioStream:
	match self.current_mode:
		MusicMode.MENU:
			return menu_music[index]
		MusicMode.GAME:
			return game_music[index]
		_:
			assert(false, "Unknown MusicMode")
			return game_music[index]
