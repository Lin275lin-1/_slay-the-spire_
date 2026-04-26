extends Relic

func on_picked_up(run_stats: RunStats, _char_stats: CharacterStats) -> void:
	run_stats.max_potion_slots += 2
