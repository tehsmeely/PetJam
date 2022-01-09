extends Node2D

enum Quality { LOW, MEDIUM, HIGH }

export (PackedScene) var bread_scene
export (float) var bread_offset = 12.0
export (Quality) var quality = Quality.MEDIUM

onready var bread_start_point = $BreadStartPoint
onready var label = $Label
onready var debug_spawn_button: Button = $SpawnButton
onready var debug_sell_button: Button = $SellButton

var bread_count = 0 setget _set_bread_count


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err = debug_spawn_button.connect("pressed", self, "_spawn_bread")
	var _err2 = debug_sell_button.connect("pressed", self, "_sell_bread")
	_update_label()


func initialise(init_bread_count: int) -> void:
	for _i in range(init_bread_count):
		self._spawn_bread()


func _spawn_bread():
	var instance = bread_scene.instance()
	var offset = bread_count * bread_offset
	bread_start_point.add_child(instance)
	instance.position.y = -offset
	self.bread_count += 1


func _sell_bread():
	if bread_count > 0:
		var bread = bread_start_point.get_child(bread_count - 1)
		print(bread)
		bread.queue_free()
		self.bread_count -= 1


func _update_label() -> void:
	label.text = "%s: %d" % [_quality_to_string(self.quality), bread_count]


func _quality_to_string(_quality: int) -> String:
	match _quality:
		Quality.LOW:
			return "Low"
		Quality.MEDIUM:
			return "Medium"
		Quality.HIGH:
			return "High"
		_:
			assert(false, "Invalid quality %i" % [_quality])
			return "ERROR"


func _set_bread_count(count: int) -> void:
	if count != bread_count:
		bread_count = count
		_update_label()
