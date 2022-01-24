extends Node

class_name HealthEffect

static func all_flours() -> Array:
	return ["Wheat", "Rye", "Spelt", "Bere"]

static func make_health_effect(
	duration: int,
	growth_rate_modifier,
	health_pct_modifier,
	set_growth_rate,
	set_health_pct,
	health_pct_impact_on_feed,
	health_velocity_impact_on_feed
) -> Dictionary:
	## All values other than duration are nullable
	return {
		"duration": duration,
		"growth_rate_modifier": growth_rate_modifier,
		"health_pct_modifier": health_pct_modifier,
		"set_growth_rate": set_growth_rate,
		"set_min_health_pct": set_health_pct,
		"health_pct_impact_on_feed": health_pct_impact_on_feed,
		"health_velocity_impact_on_feed": health_velocity_impact_on_feed
	}

static func colour_of_flour(name: String) -> Color:
	match name:
		"Wheat":
			return Color.white
		"Rye":
			return Color(0.45, 0.52, 0.08, 1.0)
		"Spelt":
			return Color(0.16, 0.47, 0.27, 1.0)
		"Bere":
			return Color(0.38, 0.16, 0.16, 1.0)
		_:
			return Color.white

static func description_of_name(name: String) -> String:
	match name:
		"Wheat":
			return "Regular flour, has normal impact on starter health"
		"Rye":
			return "Ensures the health of the starter never drops too low for 2 days"
		"Spelt":
			return "Boosts the quality of bread made with the starter for 3 days"
		"Bere":
			return "Makes starter growth rampant for 2 days, but is harmful to initial health"
		_:
			assert(false, "Unknown flour name for health effect %s" % [name])
			return ""

static func health_effect_of_name(name: String) -> Dictionary:
	match name:
		"Wheat":
			return make_health_effect(0, null, null, null, null, 30.0, 30.0)
		"Rye":
			return make_health_effect(2, null, null, null, 31.0, -20.0, -2.5)
		"Spelt":
			return make_health_effect(3, null, 1.10, null, null, 20.0, 10.0)
		"Bere":
			return make_health_effect(2, 1.5, null, null, null, -20.0, 10.0)
		_:
			assert(false, "Unknown flour name for health effect %s" % [name])
			return make_health_effect(0, null, null, null, null, null, null)
