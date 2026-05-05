extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, _select_deck_view: DeckView) -> void:
	char_stats.max_health += 11
	char_stats.health += 11
