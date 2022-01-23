extends Node2D

export (float) var acceleration = -0.4

var health_pct := 50.0 setget _set_health_pct
var velocity := 0.0
var active_effects = []

var health_zone setget _set_health_zone

onready var progress_bar = $ProgressBar


func _ready():
	pass


func end_of_day(day_delta: float) -> void:
	delayed_process(day_delta)
	_decrement_health_effects()


func delayed_process(delta):
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
	self.health_pct = clamp(self.health_pct - 20, 0.0, 100.0)


func add_effect(effect: Dictionary) -> void:
	self.active_effects.append(effect)


func get_growth_rate() -> float:
	var growth_rate = null
	match self.health_zone:
		Global.HealthZone.GOLD:
			growth_rate = 2.0
		Global.HealthZone.GOOD:
			growth_rate = 1.0
		Global.HealthZone.FINE:
			growth_rate = 0.0
		Global.HealthZone.BAD:
			growth_rate = -1.0
		_:
			growth_rate = 0.0

	var set_effect = _get_active_effect("set_growth_rate")
	var modify_effect = _get_active_effect("growth_rate_modifier")

	if set_effect != null:
		return set_effect

	var modifier = 1.0
	if modify_effect != null:
		modifier = modify_effect

	return growth_rate * modifier


func get_mouth_mode() -> float:
	match self.health_zone:
		Global.HealthZone.GOLD:
			return 0.0
		Global.HealthZone.GOOD:
			return 1.0
		Global.HealthZone.FINE:
			return 2.0
		Global.HealthZone.BAD:
			return 3.0
		_:
			return 0.0


func _set_health_pct(new_health_pct: float) -> void:
	health_pct = new_health_pct

	var effective_health_pct = health_pct
	var set_min_effect = _get_active_effect("set_min_health_pct")
	var modify_effect = _get_active_effect("growth_rate_modifier")

	if modify_effect != null:
		effective_health_pct *= modify_effect

	if set_min_effect != null and effective_health_pct < set_min_effect:
		effective_health_pct = set_min_effect

	if health_pct > 95:
		self.health_zone = Global.HealthZone.GOLD
	elif health_pct > 70.0:
		self.health_zone = Global.HealthZone.GOOD
	elif health_pct > 30.0:
		self.health_zone = Global.HealthZone.FINE
	else:
		self.health_zone = Global.HealthZone.BAD


func _set_health_zone(new_health_zone: int) -> void:
	match new_health_zone:
		Global.HealthZone.GOLD:
			progress_bar.self_modulate = Color("08ff44")
		Global.HealthZone.GOOD:
			progress_bar.self_modulate = Color("08ff44")
		Global.HealthZone.FINE:
			progress_bar.self_modulate = Color("f9ff19")
		Global.HealthZone.BAD:
			progress_bar.self_modulate = Color("f54a4a")

	health_zone = new_health_zone


var save_name = "GamePetHealth"


func save() -> Dictionary:
	return {"health_pct": self.health_pct, "velocity": self.velocity}


func load(data: Dictionary) -> void:
	self.health_pct = data["health_pct"]
	self.velocity = data["velocity"]


func _decrement_health_effects() -> void:
	var remove_indices = []
	var i = 0
	for effect in self.active_effects:
		effect["duration"] = effect["duration"] - 1
		## TODO: Cutoff might need to be 0, depends on order of operation, we'll see
		if effect["duration"] <= 0:
			remove_indices.append(i)

	# Reverse list so we remove indiced from last first, so they always match up
	remove_indices.invert()
	for index in remove_indices:
		self.active_effects.remove(index)


func debug_string() -> String:
	var info = PoolStringArray(
		[
			"Health_pct: %s" % [self.health_pct],
			"Velocity: %s" % [self.velocity],
			"",
		]
	)
	var info_effects = []
	for effect in self.active_effects:
		info_effects.append(to_json(effect))

	info.append_array(PoolStringArray(info_effects))
	return info.join("\n")


func _get_active_effect(effect_name: String) -> float:
	var final = null
	var min_duration = null
	## In the case of effect collision, shorter duration wins
	for effect in self.active_effects:
		if effect.get(effect_name) != null:
			if min_duration == null or effect["duration"] < min_duration:
				final = effect.get(effect_name)

	return final
