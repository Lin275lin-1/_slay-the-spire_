extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats) -> void:
	char_stats.max_health += 10
	char_stats.health += 10
