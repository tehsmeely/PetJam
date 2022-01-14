extends Node2D

export (NodePath) var low_quality_shelf_node
export (NodePath) var medium_quality_shelf_node
export (NodePath) var high_quality_shelf_node

onready var low_quality_shelf = get_node(low_quality_shelf_node)
onready var medium_quality_shelf = get_node(medium_quality_shelf_node)
onready var high_quality_shelf = get_node(high_quality_shelf_node)


func add_bread(quality: int) -> void:
	match quality:
		Global.Quality.LOW:
			low_quality_shelf.spawn_bread()
		Global.Quality.MEDIUM:
			medium_quality_shelf.spawn_bread()
		Global.Quality.HIGH:
			high_quality_shelf.spawn_bread()
