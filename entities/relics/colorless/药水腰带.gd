extends Relic

func on_picked_up(run_stats: RunStats, _char_stats: CharacterStats, _deck_view: DeckView) -> void:
	run_stats.max_potion_slots += 2
