extends Node2D

export (NodePath) var low_quality_shelf_node
export (NodePath) var medium_quality_shelf_node
export (NodePath) var high_quality_shelf_node

onready var low_quality_shelf = get_node(low_quality_shelf_node)
onready var medium_quality_shelf = get_node(medium_quality_shelf_node)
onready var high_quality_shelf = get_node(high_quality_shelf_node)

func add_bread(health_zone: int) -> void:
	match health_zone:
		Global.HealthZone.BAD:
			low_quality_shelf.spawn_bread()           
		Global.HealthZone.FINE:
			medium_quality_shelf.spawn_bread()           
		Global.HealthZone.GOOD:
			high_quality_shelf.spawn_bread()           
		Global.HealthZone.GOLD:
			high_quality_shelf.spawn_bread()           
			high_quality_shelf.spawn_bread()           
