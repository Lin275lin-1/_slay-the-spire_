extends Relic

func on_picked_up(run_stats: RunStats, _char_stats: CharacterStats, _select_deck_view: DeckView) -> void:
	run_stats.gold += 150
