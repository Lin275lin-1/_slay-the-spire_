extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, select_deck_view: DeckView) -> void:
	var selected_cards := await select_deck_view.select_card_pile(
		char_stats.get_deck().filter(func(card: Card): return card.can_be_removed()),
		2, 2, "选择两张卡牌删除"
	)
	for card: Card in selected_cards:
		char_stats.deck.remove_card(card)
	char_stats.health -= 12
