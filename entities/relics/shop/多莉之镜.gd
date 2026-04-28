extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, select_deck_view: DeckView) -> void:
	var cards := await select_deck_view.select_card_pile(char_stats.get_deck(), 1, 1, "选择一张牌复制")
	if !cards.is_empty():
		char_stats.add_card_to_deck(cards[0].duplicate())
