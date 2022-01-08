extends Node2D

export (float) var min_fill_eye_scale_threshold_pct = 25
export (float) var eye_top_offset_max = 17

onready var eyes_animation_player = $FillLevel/EyesSprite/AnimationPlayer
onready var blink_timer = $FillLevel/EyesSprite/BlinkTimer

onready var fill_max_pos = $FillMax
onready var fill_min_pos = $FillMin
onready var fill_level_pos = $FillLevel
onready var gloop_sprite = $GloopSprite
onready var gloop_sprite_offset = gloop_sprite.position.y - fill_max_pos.position.y
onready var fill_level_offset = fill_level_pos.position.y - fill_max_pos.position.y
onready var eyes_offset = $FillLevel/EyesSprite.position.y

func _ready():
	var _err = blink_timer.connect("timeout", eyes_animation_player, "play", ["blink"])



func set_fill_level_pct(pct: float) -> void:
	var max_y = fill_min_pos.position.y - fill_max_pos.position.y
	var y_add = ((100.0-pct) / 100.0) * max_y
	fill_level_pos.position.y = fill_max_pos.position.y + fill_level_offset + y_add
	gloop_sprite.position.y = fill_max_pos.position.y + gloop_sprite_offset + y_add

	if pct < min_fill_eye_scale_threshold_pct:
		var scale =  pct / min_fill_eye_scale_threshold_pct
		$FillLevel/EyesSprite.scale.y = scale
		#$FillLevel/EyesSprite.position.y = eyes_offset * scale
	else:
		$FillLevel/EyesSprite.scale.y = 1.0
	$FillLevel/EyesSprite.position.y = eye_top_offset_max * (pct/100.0)
	



