extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, _select_deck_view: DeckView) -> void:
	for card: Card in char_stats.get_deck():
		if card.id == "打击" or card.id == "防御":
			card.ethereal = true
