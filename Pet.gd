extends Node2D

export (float) var min_fill_eye_scale_threshold_pct = 25
export (float) var eye_top_offset_max = 17
export (float) var mouth_top_offset_max = 42
export (float) var growth_pct_per_s = 1.0

var fill_level_pct := 50.0 setget set_fill_level_pct
var update_cull = 0

onready var eyes_animation_player = $FillLevel/EyesSprite/AnimationPlayer
onready var blink_timer = $FillLevel/EyesSprite/BlinkTimer
onready var mouth = $FillLevel/Mouth
onready var eyes = $FillLevel/EyesSprite
onready var fill_label = $FillLabel
onready var health = $Health

onready var fill_max_pos = $FillMax
onready var fill_min_pos = $FillMin
onready var fill_level_pos = $FillLevel
onready var gloop_sprite = $GloopSprite
onready var gloop_sprite_offset = gloop_sprite.position.y - fill_max_pos.position.y
onready var fill_level_offset = fill_level_pos.position.y - fill_max_pos.position.y
onready var eyes_offset = $FillLevel/EyesSprite.position.y


func _ready():
	var _err = blink_timer.connect("timeout", eyes_animation_player, "play", ["blink"])


func _process(delta):
	update_cull += 1
	if update_cull == 4:
		#var growth = ((delta * growth_pct_per_s) / 100.0) * fill_level_pct
		var growth = ((delta * health.get_growth_rate()) / 100.0) * fill_level_pct

		self.fill_level_pct = self.fill_level_pct + growth
		update_cull = 0


func end_of_day() -> void:
	print("End of day")


func feed() -> void:
	self.fill_level_pct += 20.0
	self.health.boost(20.0)


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
			assert(false, "Invalid HealthZone from health")
			return 0


func set_fill_level_pct(pct: float) -> void:
	if pct > 100.0:
		print("MAX")
		pct = 100.0
	fill_level_pct = pct
	var max_y = fill_min_pos.position.y - fill_max_pos.position.y
	var y_add = ((100.0 - pct) / 100.0) * max_y
	fill_level_pos.position.y = fill_max_pos.position.y + fill_level_offset + y_add
	gloop_sprite.position.y = fill_max_pos.position.y + gloop_sprite_offset + y_add

	if pct < min_fill_eye_scale_threshold_pct:
		var scale = pct / min_fill_eye_scale_threshold_pct
		eyes.scale.y = scale
		mouth.scale.y = scale
	else:
		eyes.scale.y = 1.0
		mouth.scale.y = 1.0
	eyes.position.y = eye_top_offset_max * (pct / 100.0)
	mouth.position.y = mouth_top_offset_max * (pct / 100.0)

	#var mouth_mode = 0
	#if (35 > pct and pct > 20) or (pct > 85 and pct < 95):
	#	mouth_mode = 1
	#elif pct <= 20 or pct >= 95:
	#	mouth_mode = 2
	var mouth_mode = health.get_mouth_mode()

	mouth.texture.region = Rect2(Vector2(mouth_mode * 64, 0), mouth.texture.region.size)

	fill_label.text = "%.0f%%" % [pct]
