extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, _select_deck_view: DeckView) -> void:
	ItemPool.current_card_pool = ItemPool.get_draftable_cards_by_color(char_stats.color + Card.COLOR.COLORLESS)
