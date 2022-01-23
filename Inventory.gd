extends Node2D

export (NodePath) var low_quality_shelf_node
export (NodePath) var medium_quality_shelf_node
export (NodePath) var high_quality_shelf_node

onready var low_quality_shelf = get_node(low_quality_shelf_node)
onready var medium_quality_shelf = get_node(medium_quality_shelf_node)
onready var high_quality_shelf = get_node(high_quality_shelf_node)
onready var sfx_player = $AudioStreamPlayer


func _ready():
	for shelf in [low_quality_shelf, medium_quality_shelf, high_quality_shelf]:
		var err = shelf.connect("bread_sold", self, "_on_bread_sold")
		Global.handle_connect_error(err)


func end_of_day() -> void:
	print("Inventory End of day")
	low_quality_shelf.randomise_price()
	medium_quality_shelf.randomise_price()
	high_quality_shelf.randomise_price()


func _on_bread_sold() -> void:
	sfx_player.play()


func camera_pos_x_offset() -> float:
	return get_node("CameraPos").position.x


func add_bread(quality: int) -> void:
	match quality:
		Global.Quality.LOW:
			low_quality_shelf.spawn_bread()
		Global.Quality.MEDIUM:
			medium_quality_shelf.spawn_bread()
		Global.Quality.HIGH:
			high_quality_shelf.spawn_bread()


var save_name = "GameInventory"


func save() -> Dictionary:
	return {
		"low_q_shelf": self.low_quality_shelf.save(),
		"medium_q_shelf": self.medium_quality_shelf.save(),
		"high_q_shelf": self.high_quality_shelf.save()
	}


func load(data: Dictionary) -> void:
	self.low_quality_shelf.load(data["low_q_shelf"])
	self.medium_quality_shelf.load(data["medium_q_shelf"])
	self.high_quality_shelf.load(data["high_q_shelf"])
