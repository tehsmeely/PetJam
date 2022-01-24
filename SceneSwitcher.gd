extends Node

var current_scene = null

var last_scene = null


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path, false, false)


func goto_scene_and_load(path):
	call_deferred("_deferred_goto_scene", path, false, true)


func push_scene(path):
	call_deferred("_deferred_goto_scene", path, true, false)


func _deferred_goto_scene(path, save: bool, call_load_after: bool) -> void:
	if save:
		self.last_scene = current_scene
		get_tree().get_root().remove_child(self.last_scene)
	else:
		self.last_scene = null
		current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	if call_load_after:
		print("Scene create. Loading")
		SaveLoad.load_all()


func pop():
	if self.last_scene != null:
		call_deferred("_deferred_pop")
	else:
		assert(false, "No saved prev scene to pop to")


func _deferred_pop() -> void:
	self.current_scene.free()
	self.current_scene = self.last_scene
	self.current_scene.visible = false
	self.last_scene = null
	get_tree().get_root().add_child(self.current_scene)
	get_tree().set_current_scene(self.current_scene)
