extends Node2D

signal overflow_occured
signal empty_occured
signal bread_baked(quality)

export (float) var min_fill_eye_scale_threshold_pct = 25
export (float) var eye_top_offset_max = 17
export (float) var mouth_top_offset_max = 42
export (float) var moustache_top_offset_max = 32
export (float) var moustache_scale_mod = 0.6
export (float) var growth_pct_per_s = 1.0
export (float) var day_delta = 20.0
export (float) var bake_fill_usage = 30.0

var fill_level_pct := 50.0 setget set_fill_level_pct
var update_cull = 0
var moustache_visible = false setget _set_moustache_visible

onready var eyes_animation_player = $FillLevel/EyesSprite/AnimationPlayer
onready var blink_timer = $FillLevel/EyesSprite/BlinkTimer
onready var mouth = $FillLevel/Mouth
onready var eyes = $FillLevel/EyesSprite
onready var moustache = $FillLevel/Moustache
onready var fill_label = $FillLabel
onready var health = $Health
onready var name_label = $NameLabel
onready var feed_ui = $FeedUI
onready var feed_sound = $Audio/FeedSound
onready var bake_sound = $Audio/BakeSound
onready var bake_button = $BakeButton

onready var fill_max_pos = $FillMax
onready var fill_min_pos = $FillMin
onready var fill_level_pos = $FillLevel
onready var gloop_sprite = $GloopSprite
onready var gloop_sprite_offset = gloop_sprite.position.y - fill_max_pos.position.y
onready var fill_level_offset = fill_level_pos.position.y - fill_max_pos.position.y
onready var eyes_offset = $FillLevel/EyesSprite.position.y


func _ready():
	var err = blink_timer.connect("timeout", eyes_animation_player, "play", ["blink"])
	Global.handle_connect_error(err)
	var err2 = feed_ui.connect("flour_fed", self, "_on_flour_fed")
	Global.handle_connect_error(err2)
	var err3 = bake_button.connect("pressed", self, "_on_bake_button")
	Global.handle_connect_error(err3)


# Not currently using this function, growth is Day only for now
func _realtime_process(delta):
	update_cull += 1
	if update_cull == 4:
		#var growth = ((delta * growth_pct_per_s) / 100.0) * fill_level_pct
		var growth = ((delta * health.get_growth_rate()) / 100.0) * fill_level_pct

		self.fill_level_pct = self.fill_level_pct + growth
		update_cull = 0


func enable_moustache() -> void:
	self.moustache_visible = true


func enable_probe() -> void:
	health.health_bar_visible = true


func end_of_day() -> void:
	var level_adjustment = (
		((day_delta * health.get_growth_rate()) / 100.0)
		* clamp(self.fill_level_pct, 30, 100)
	)
	print(
		(
			"Level Adjustment ((%d * %d)%%): %d"
			% [day_delta, health.get_growth_rate(), level_adjustment]
		)
	)
	health.end_of_day(day_delta)
	self.fill_level_pct += level_adjustment
	print("End of day")


func _on_flour_fed(flour_name: String) -> void:
	var flour_effect = HealthEffect.health_effect_of_name(flour_name)
	self.fill_level_pct += 20.0
	self.health.add_effect(flour_effect)
	self.feed_sound.play()


func _on_bake_button() -> void:
	if self.fill_level_pct > self.bake_fill_usage:
		_on_actually_bake()


func _on_actually_bake() -> void:
	self.bake_sound.play()
	self.fill_level_pct -= self.bake_fill_usage
	emit_signal("bread_baked", self.get_quality())


func debug_bake() -> void:
	self._on_bake_button()


func debug_feed() -> void:
	self.fill_level_pct += 20.0
	self.health.boost(20.0)


func _on_overspill() -> void:
	print("Overflow!")
	## Tell main ui to show overspill ui
	## And charge cleanup gold
	emit_signal("overflow_occured")


func _on_empty() -> void:
	print("Empty!")
	## Tell main ui to end game
	emit_signal("empty_occured")


func add_flour(flour_name):
	self.feed_ui.add_quantity(flour_name)


func set_name(name: String) -> void:
	name_label.text = name


func camera_pos_x_offset() -> float:
	return get_node("CameraPos").position.x


func penalise_health() -> void:
	print("TODO. Penalising health from overflow")


func get_quality() -> int:
	match self.health.health_zone:
		Global.HealthZone.BAD:
			return Global.Quality.LOW
		Global.HealthZone.FINE:
			return Global.Quality.MEDIUM
		Global.HealthZone.GOOD:
			return Global.Quality.HIGH
		Global.HealthZone.GOLD:
			return Global.Quality.HIGH
		_:
			assert(false, "Invalid HealthZone from health: %d" % [self.health.health_zone])
			return 0


func set_fill_level_pct(pct: float) -> void:
	if pct > 100.0:
		self._on_overspill()
		pct = 90.0
	if pct <= 0.5:
		pct = 0.0
		self._on_empty()

	fill_level_pct = pct
	var max_y = fill_min_pos.position.y - fill_max_pos.position.y
	var y_add = ((100.0 - pct) / 100.0) * max_y
	fill_level_pos.position.y = fill_max_pos.position.y + fill_level_offset + y_add
	gloop_sprite.position.y = fill_max_pos.position.y + gloop_sprite_offset + y_add

	if pct < min_fill_eye_scale_threshold_pct:
		var scale = pct / min_fill_eye_scale_threshold_pct
		eyes.scale.y = scale
		mouth.scale.y = scale
		moustache.scale.y = scale * moustache_scale_mod
	else:
		eyes.scale.y = 1.0
		mouth.scale.y = 1.0
		moustache.scale.y = 1.0 * moustache_scale_mod
	eyes.position.y = eye_top_offset_max * (pct / 100.0)
	mouth.position.y = mouth_top_offset_max * (pct / 100.0)
	moustache.position.y = moustache_top_offset_max * (pct / 100.0)

	var mouth_mode = health.get_mouth_mode()

	mouth.texture.region = Rect2(Vector2(mouth_mode * 64, 0), mouth.texture.region.size)

	fill_label.text = "%.0f%%" % [pct]


func _set_moustache_visible(mv: bool) -> void:
	#TODO: Set moustache visible
	print("MOUSTACH!")
	moustache_visible = mv
	moustache.visible = mv


var save_name = "GamePet"


func save() -> Dictionary:
	return {"fill_level_pct": self.fill_level_pct, "moustache_visible": self.moustache_visible}


func load(data: Dictionary) -> void:
	self.fill_level_pct = data["fill_level_pct"]
	self.moustache_visible = data["moustache_visible"]
