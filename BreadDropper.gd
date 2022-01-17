extends Node2D

export (PackedScene) var dropping_bread
export (float) var fall_speed = 100.0
export (float) var bread_viewport_offset = 32
export (float) var spawn_delay = 0.6
export (float) var spawn_delay_variance = 0.3

onready var timer = $Timer

onready var breads = $Breads

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

	spawn_bread()
	var _err = timer.connect("timeout", self, "_on_timer_timeout")


func _on_timer_timeout() -> void:
	timer.wait_time = rng.randf_range(
		spawn_delay - spawn_delay_variance, spawn_delay + spawn_delay_variance
	)
	spawn_bread()


func spawn_bread() -> void:
	var x = rng.randf_range(0.0, get_viewport().size.x)

	var bread_instance = dropping_bread.instance()

	bread_instance.position = Vector2(x, -bread_viewport_offset)

	breads.add_child(bread_instance)


func _physics_process(delta):
	var max_y = get_viewport().size.y + bread_viewport_offset
	for bread in breads.get_children():
		bread.position.y += fall_speed * delta
		if bread.position.y >= max_y:
			bread.queue_free()
