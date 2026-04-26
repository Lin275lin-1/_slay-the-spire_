extends Relic

func on_picked_up(_run_stats: RunStats, char_stats: CharacterStats, select_deck_view: DeckView) -> void:
	var enchantment: Enchantment = ItemPool.get_enchantment_by_name("动量")
	enchantment.stacks = 5
	if enchantment:
		var candidates: Array[Card] = char_stats.get_deck().filter(
			func(card: Card): return enchantment.can_enchant(card)
			)
		var cards: Array[Card] = await select_deck_view.select_card_pile(candidates, 0, 1, "选择一张牌附魔")
		for card: Card in cards:
			card.enchantment = enchantment.duplicate()
