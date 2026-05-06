extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, select_deck_view: DeckView) -> void:
	var selected_cards := await select_deck_view.select_card_pile(
		char_stats.get_deck().filter(func(card: Card): return card.can_be_removed())
		,1, 1, "选择一张卡牌删除"
	)
	if !selected_cards.is_empty():
		char_stats.deck.remove_card(selected_cards[0])
	
