extends Node2D

export (float) var acceleration = -0.4

var health_pct := 50.0 setget _set_health_pct
var velocity := 0.0

var health_zone setget _set_health_zone

onready var progress_bar = $ProgressBar

enum HealthZone { BAD, FINE, GOOD, GOLD }


func _ready():
	pass


func _process(delta):
	#v = u+at
	self.velocity = self.velocity + (self.acceleration * delta)

	# d = 1/2(u+v)t	too lazy to use u, so u = v, so d = vt

	var new_health_pct = self.health_pct + (self.velocity * delta)

	self.health_pct = clamp(new_health_pct, 0.0, 100.0)

	progress_bar.value = health_pct
	if health_pct == 0.0:
		self.velocity = 0.0


func boost(boost_velocity: float) -> void:
	self.velocity += boost_velocity


func get_growth_rate() -> float:
	match self.health_zone:
		HealthZone.GOLD:
			return 2.0
		HealthZone.GOOD:
			return 1.0
		HealthZone.FINE:
			return 0.0
		HealthZone.BAD:
			return -1.0
		_:
			return 0.0


func _set_health_pct(new_health_pct: float) -> void:
	health_pct = new_health_pct

	if health_pct > 95:
		self.health_zone = HealthZone.GOLD
	elif health_pct > 70.0:
		self.health_zone = HealthZone.GOOD
	elif health_pct > 30.0:
		self.health_zone = HealthZone.FINE
	else:
		self.health_zone = HealthZone.BAD


func _set_health_zone(new_health_zone: int) -> void:
	match new_health_zone:
		HealthZone.GOLD:
			progress_bar.self_modulate = Color("08ff44")
		HealthZone.GOOD:
			progress_bar.self_modulate = Color("08ff44")
		HealthZone.FINE:
			progress_bar.self_modulate = Color("f9ff19")
		HealthZone.BAD:
			progress_bar.self_modulate = Color("f54a4a")

	health_zone = new_health_zone