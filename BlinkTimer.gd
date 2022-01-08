extends Timer

export (float) var min_wait_time = 1.0
export (float) var max_wait_time = 3.0

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	self._randomise_wait_time()
	var _err = self.connect("timeout", self, "_randomise_wait_time")


func _randomise_wait_time() -> void:
	self.wait_time = rng.randf_range(self.min_wait_time, self.max_wait_time)

